//
//  NewChatViewController.swift
//  ChatBot
//
//  Created by 김민규 on 2023/02/21.
//

import UIKit
import SnapKit
import FirebaseAuth

protocol NewChatViewControllerDelegate {
	func didSelectedPersonToChat(selectedUser: Sender)
}

class NewChatViewController: UIViewController {
	
	var delegate: NewChatViewControllerDelegate?
	
	let completionBotButton: UIButton = {
		let button = UIButton()
		button.setTitle("completion bot", for: .normal)
		return button
	}()
	let editingBotButton: UIButton = {
		let button = UIButton()
		button.setTitle("editing bot", for: .normal)
		return button
	}()
	let storyBotButton: UIButton = {
		let button = UIButton()
		button.setTitle("story bot", for: .normal)
		return button
	}()
	
	let anotherUserButton: UIButton = {
		let button = UIButton()
		button.setTitle("another user bot", for: .normal)
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		addTargetForButtons()
		addSubviews()
		setupLayout()
	}
	

	
	private func addSubviews() {
		view.addSubview(completionBotButton)
		view.addSubview(editingBotButton)
		view.addSubview(storyBotButton)
		view.addSubview(anotherUserButton)
	}
	
	private func setupLayout() {
		completionBotButton.snp.makeConstraints{ make in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(-32)
		}
		
		editingBotButton.snp.makeConstraints{ make in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview()
		}
		
		storyBotButton.snp.makeConstraints{ make in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(32)
		}
		
		anotherUserButton.snp.makeConstraints{ make in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(64)
		}
	}
	
}

// MARK: Button Related
extension NewChatViewController {
	private func addTargetForButtons() {
		storyBotButton.addTarget(self, action: #selector(startChat(sender:)), for: .touchUpInside)
		completionBotButton.addTarget(self, action: #selector(startChat(sender:)), for: .touchUpInside)
		editingBotButton.addTarget(self, action: #selector(startChat(sender:)), for: .touchUpInside)
		anotherUserButton.addTarget(self, action: #selector(startChat(sender:)), for: .touchUpInside)
	}
	
	@objc
	private func startChat(sender: UIControl) {
		var designatedUser: Sender
		switch sender {
		case storyBotButton:
			designatedUser = .bot(.storyBot)
		case completionBotButton:
			designatedUser = .bot(.completionBot)
		case editingBotButton:
			designatedUser = .bot(.editingBot)
		default:
			let currentUser = Auth.auth().currentUser!.email
			designatedUser = .user(currentUser == "gu79917991@gmail.com" ? "gu7991@gmail.com" : "gu79917991@gmail.com")
			print("Start Chat With User")
		}
		self.dismiss(animated: true) { [weak self] in
			self?.delegate?.didSelectedPersonToChat(selectedUser: designatedUser)
		}
	}
}
