//
//  Constants.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/19.
//

import Foundation


struct FS {
	struct messages {
		static let collectionName = "messages"
		static let senderField = "sender"
		static let bodyField = "body"
		static let dateField = "date"
		static let chatRoomIdField = "chatRoomId"
	}
	
	struct chatRooms {
		static let collectionName = "chatRooms"
		static let lastChatField = "lastChat"
		static let dateField = "date"
		static let usersField = "users"
	}
	
	struct users {
		static let collectionName = "users"
		static let emailField = "email"
		static let chatRoomSubCollection = chatRooms.collectionName
	}
}


enum BotType: String {
	case storyBot = "storyBot"
	case completionBot = "completionBot"
	case editingBot = "editingBot"
	
	func getDisplayName() -> String {
		switch self {
		case .storyBot:
			return "Story Bot"
		case .completionBot:
			return "Completion Bot"
		case .editingBot:
			return "Editing Bot"
		}
	}
}

enum Sender {
	case bot (BotType)
	case user (String)
	
	var rawValue: String {
		switch self {
		case .user(let email):
			return email
		case .bot(let chatBot):
			return chatBot.rawValue
		}
	}
}
