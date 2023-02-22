//
//  MessageManger.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/20.
//

import Foundation
import FirebaseFirestore

struct MessageManager {
	
	static func addMessage(message: Message, chatRoom: ChatRoom, completionHandler: (() -> Void)?) {
		let db = Firestore.firestore()
		
		db.collection(FS.messages.collectionName)
			.document(message.id)
			.setData([
				FS.messages.chatRoomIdField: chatRoom.id,
				FS.messages.dateField: message.date,
				FS.messages.senderField: message.sender.rawValue,
				FS.messages.bodyField: message.body,
			]) { error in
				guard error == nil else {
					print("Error Adding Message, \(error!)")
					return
				}

				// Update Chatroom
				let lastChat = message.body
				chatRoom.lastChat = lastChat
				print(chatRoom)
				ChatRoomManger.updateChatRoom(chatRoom)
//				print("Added Message")
				
				if let safeHandler = completionHandler {
					safeHandler()
				}
				
			}
	}
	
	static func loadMessages(chatRoom: ChatRoom, completionHandler: @escaping ([Message]) -> Void) {
		let db = Firestore.firestore()
		
		
		db.collection(FS.messages.collectionName)
			.whereField(FS.messages.chatRoomIdField, isEqualTo: chatRoom.id)
			.order(by: FS.messages.dateField)
			.addSnapshotListener { snapshot, error in
				
				var messages = [Message]()
				
				guard error == nil else {
					print("Error fetching messages, \(error!)")
					return
				}
				
				guard let documents = snapshot?.documents else {
					print("Error fetching messages, snapshot is nil")
					return
				}
				
				
				
				for doc in documents {
					let data = doc.data()
					let docId = doc.documentID
					
					guard let senderString = data[FS.messages.senderField] as? String,
						  let body = data[FS.messages.bodyField] as? String,
						  let date = data[FS.messages.dateField] as? TimeInterval
					else {
						print("There's no sender or body in the document")
						return
					}
					
					var typedSender: Sender
					
					switch senderString {
					case BotType.completionBot.rawValue:
						typedSender = Sender.bot(.completionBot)
					case BotType.editingBot.rawValue:
						typedSender = Sender.bot(.editingBot)
					case BotType.storyBot.rawValue:
						typedSender = Sender.bot(.storyBot)
					default:
						typedSender = Sender.user(senderString)
					}
					
					let message = Message(sender: typedSender, body: body, date: date, id: docId)
					
					messages.append(message)
				} // for doc in documents
				
				completionHandler(messages)
			} // db.collection.getDocuments
	} // loadMessages
	
	
}
