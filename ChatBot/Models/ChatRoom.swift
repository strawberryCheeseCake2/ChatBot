//
//  Chatroom.swift
//  ChatBot
//
//  Created by 김민규 on 2023/02/21.
//

import Foundation
import FirebaseAuth

class ChatRoom {
	var id: String
	var participants: [Sender]
	var lastChat: String = ""
	
	init(id: String, participants: [Sender], lastChat: String) {
		self.id = id
		self.participants = participants
		self.lastChat = lastChat
	}
	
	convenience init(startChatWith: Sender) {
		let currentUserEmail = Auth.auth().currentUser!.email!
		
		let newParticipants: [Sender] = [.user(currentUserEmail), startChatWith]
		self.init(id: UUID().uuidString, participants: newParticipants, lastChat: "")
	}
	
	func userStringify() -> [String] {
		let stringified = self.participants.map { user in
			return user.rawValue
		}
		
		return stringified
	}
	
	func getUsersExcludingCurrentUser() -> [Sender] {
		let filteredUsers = self.participants.filter { user in
			switch user {
			case .bot(_):
				return true
			case .user(let email):
				return email != Auth.auth().currentUser!.email
			}
		}
		return filteredUsers
	} // getUsersExcludingCurrentUser
	
	
	
}
