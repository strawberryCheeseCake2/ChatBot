//
//  ViewController.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/18.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
	
	var chatRooms = [ChatRoom]()
	var isLoding = false
	
	let activityIndicator: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView()
		view.style = .large
		view.startAnimating()
		return view
	}()
	
	let chatRoomTableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		return tableView
	}()
	
	lazy var newChatBarButton: UIBarButtonItem = {
		let button = UIBarButtonItem(image: .init(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newChatButtonPressed))
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .iosDefault
		loadConversations()
		configureNavigationBar()
		configureTableView()
		addSubviews()
		setupLayout()
	}
	
	private func loadConversations() {
		ChatRoomManger.loadChatRooms { [weak self] rooms in
			self?.chatRooms = rooms
			print(rooms)
			self?.chatRoomTableView.reloadData()
			self?.activityIndicator.stopAnimating()
		}
	}

	
	private func configureNavigationBar() {
		self.title = "Chats"
		navigationItem.rightBarButtonItem = newChatBarButton
	}
	
	private func configureTableView() {
		chatRoomTableView.delegate = self
		chatRoomTableView.dataSource = self
		chatRoomTableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.id)
	}
	
	private func addSubviews() {
		view.addSubview(chatRoomTableView)
		view.addSubview(activityIndicator)
	}
	
	private func setupLayout() {
		chatRoomTableView.snp.makeConstraints{ make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
		
		activityIndicator.snp.makeConstraints{ make in
			make.center.equalToSuperview()
			make.width.equalTo(64)
			make.height.equalTo(64)
		}
	}
	
	@objc
	private func newChatButtonPressed() {
		let newChatVC = NewChatViewController()
		newChatVC.delegate = self
		self.present(newChatVC, animated: true)
	}
	
	func getBotNameToDisplay(room: ChatRoom) -> String {
		let currentUser = Auth.auth().currentUser!.email
		let otherPerson = room.participants.filter { person in
			person.rawValue != currentUser
		}.first
		
		var otherPersonDisplayName: String
		
		switch otherPerson {
		case .bot(let chatBot):
			otherPersonDisplayName = chatBot.getDisplayName()
		default:
			otherPersonDisplayName = otherPerson!.rawValue
			print("Username was thrown")
		}
		
		return otherPersonDisplayName
	}
	
	
} // ViewController

extension ChatViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chatRooms.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.id, for: indexPath) as! ChatRoomTableViewCell
		let room = chatRooms[indexPath.row]
		
		let otherPersonDisplayName = getBotNameToDisplay(room: room)

		cell.configureContents(username: otherPersonDisplayName, latestChat: room.lastChat)
		
		return cell
	}
	
}

extension ChatViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (view.window?.windowScene?.screen.bounds.height)! * 0.105
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let selectedChatRoom = chatRooms[indexPath.row]
		let vc = ChatRoomViewController(chatRoom: selectedChatRoom)
		vc.title = getBotNameToDisplay(room: selectedChatRoom)
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension ChatViewController: NewChatViewControllerDelegate {
	func didSelectedPersonToChat(selectedUser: Sender) {
		let newChatRoom = ChatRoom(startChatWith: selectedUser)
		let chatRoomVC = ChatRoomViewController(chatRoom: newChatRoom)
		
		let otherPersonDisplayName = getBotNameToDisplay(room: newChatRoom)
		chatRoomVC.title = otherPersonDisplayName
		
		navigationController?.pushViewController(chatRoomVC, animated: true)
	}
	
	
}

extension ChatViewController: ChatRoomViewControllerDelegate {
	func didUpdateChatRoom() {
		chatRoomTableView.reloadData()
	}
	
	
}
