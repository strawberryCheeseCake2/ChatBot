//
//  ChatRoomViewController.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/19.
//

import FirebaseAuth
import FirebaseFirestore
import SnapKit
import UIKit

protocol ChatRoomViewControllerDelegate {
	func didUpdateChatRoom()
}

class ChatRoomViewController: UIViewController {
	lazy var botReplyManger = BotReplyManager()
	
	var delegate: ChatRoomViewControllerDelegate?
	
	var messages: [Message] = []
	
	var chatRoom: ChatRoom
	var isLoading: Bool = false
	
	let chatBubbleTableView: UITableView = {
		let tableView = UITableView()
		tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		return tableView
	}()
	
	let chatTextViewSection = ChatTextViewSection()
	
	init(chatRoom: ChatRoom) {
		self.chatRoom = chatRoom
		super.init(nibName: nil, bundle: nil)
		self.hidesBottomBarWhenPushed = true
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .iosDefault
		
		loadChatBubbles()
		configureTextViewSection()
		configureTableView()
		addSubviews()
		setupLayout()
	}
	
	private func loadChatBubbles() {
		MessageManager.loadMessages(chatRoom: chatRoom) { [weak self] result in
			self?.messages = []
			self?.messages = result
			self?.chatBubbleTableView.reloadData()
			
			guard let count = self?.messages.count else {
				print("self is nil")
				return
			}
			
			if count > 0 {
				let indexPath = IndexPath(row: (self?.messages.count)! - 1, section: 0)
				self?.chatBubbleTableView.scrollToRow(at: indexPath, at: .top, animated: true)
			}
		}
	}
	
	private func configureTextViewSection() {
		chatTextViewSection.chatTextView.delegate = self
		chatTextViewSection.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
	}
	
	private func configureTableView() {
		chatBubbleTableView.delegate = self
		chatBubbleTableView.dataSource = self
		chatBubbleTableView.register(ChatBubbleTableViewCell.self, forCellReuseIdentifier: ChatBubbleTableViewCell.id)
		chatBubbleTableView.separatorStyle = .none
	}
	
	private func addSubviews() {
		view.addSubview(chatBubbleTableView)
		view.addSubview(chatTextViewSection)
	}
	
	private func setupLayout() {
		chatTextViewSection.snp.makeConstraints { make in
			make.width.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
			make.height.equalTo(48)
		}
		
		chatBubbleTableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.width.equalToSuperview()
			make.bottom.equalTo(chatTextViewSection.snp.top)
		}
	}
}

// MARK: Table View DataSource

extension ChatRoomViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleTableViewCell.id, for: indexPath) as! ChatBubbleTableViewCell
		cell.selectionStyle = .none
		
		let message = messages[indexPath.row]
		
		cell.chatLabel.text = message.body
		switch message.sender {
		case .user(let email):
			if email == Auth.auth().currentUser!.email {
				cell.rightSpacer.isHidden = true
				cell.leftSpacer.isHidden = false
				cell.bubbleContainer.backgroundColor = .systemBlue
				cell.chatLabel.textColor = .white
			} else {
				cell.leftSpacer.isHidden = true
				cell.rightSpacer.isHidden = false
				cell.bubbleContainer.backgroundColor = .systemFill
				cell.chatLabel.textColor = .black
			}
		default:
			cell.leftSpacer.isHidden = true
			cell.rightSpacer.isHidden = false
			cell.bubbleContainer.backgroundColor = .systemTeal
		}
		
		return cell
	}
}

// MARK: Table View Delegate

extension ChatRoomViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

// MARK: Text View Delegate

extension ChatRoomViewController: UITextViewDelegate {
	@objc
	func sendButtonPressed() {
		let textView = chatTextViewSection.chatTextView
		guard textView.text != "" else {
			print("Won't save")
			return
		}
		
		guard let messageBody = chatTextViewSection.chatTextView.text,
		      let messageSender = Auth.auth().currentUser?.email
		else { return }
		
		let newMessage = Message(sender: .user(messageSender), body: messageBody)
		
		MessageManager.addMessage(message: newMessage, chatRoom: chatRoom) { [weak self] in
			print("Completion")
			
			// Bot Sends Message
			let otherUser = self?.chatRoom.getUsersExcludingCurrentUser().first
			guard let safeOtherUser = otherUser else { return }
			
			print(type(of: Sender.user("gu7991@gmail.com")))
			var botReplyMessage = "Error"
			
			switch safeOtherUser {
			case .bot(.storyBot):
				self?.botReplyManger.getStoryReply { story in
					botReplyMessage =
						"title: \(story.title)\nHere's the story:\n\(story.story)"
					
					let botReply = Message(sender: safeOtherUser, body: botReplyMessage)
					// 네트워킹 중에 나감
					MessageManager.addMessage(message: botReply, chatRoom: self!.chatRoom, completionHandler: {})
				}

			case .bot(.completionBot):
				self?.botReplyManger.getCompletionReply(question: newMessage.body) { answer in
					
					botReplyMessage = answer
						
					let botReply = Message(sender: safeOtherUser, body: botReplyMessage)
					
					MessageManager.addMessage(message: botReply, chatRoom: self!.chatRoom, completionHandler: {})
				}
			case .bot(.editingBot):
				self?.botReplyManger.getEditingReply(text2Edit: newMessage.body) { answer in
					
					botReplyMessage = answer
						
					let botReply = Message(sender: safeOtherUser, body: botReplyMessage)
					
					MessageManager.addMessage(message: botReply, chatRoom: self!.chatRoom, completionHandler: {})
				}
			default:
				break
			}
		}
		
		delegate?.didUpdateChatRoom()
		
		textView.endEditing(true)
	}
	
	func setVisibilityOfSendButton(isEmpty empty: Bool) {
		if empty {
			
			UITextView.animate(withDuration: 0.2, animations: {
				self.chatTextViewSection.sendButton.isHidden = true
				self.chatTextViewSection.layoutIfNeeded()
			})
		} else {
			
			UITextView.animate(withDuration: 0.2, animations: {
				self.chatTextViewSection.sendButton.isHidden = false
				self.chatTextViewSection.layoutIfNeeded()
			})
		}
	}
	
	func adjustTextViewHeight() {
		let fixedWidth = chatTextViewSection.chatTextView.frame.size.width
		let newSize = chatTextViewSection.chatTextView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
		
		chatTextViewSection.snp.updateConstraints { make in
			make.height.equalTo(newSize.height + 18)
		}
		UIView.animate(withDuration: 0.3, animations: {
			//			self.chatTextViewSection.layoutIfNeeded()
			self.view.layoutIfNeeded()
		})
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		textView.text = "Message"
		textView.textColor = .placeholderText
		adjustTextViewHeight()
		setVisibilityOfSendButton(isEmpty: true)
	}
	
	func textViewDidChange(_ textView: UITextView) {
		setVisibilityOfSendButton(isEmpty: textView.text == "")
		adjustTextViewHeight()
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == .placeholderText {
			textView.text = ""
			textView.textColor = .black
		}
	} // didBeginEditing
}
