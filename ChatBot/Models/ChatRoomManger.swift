//
//  ChatRoomManger.swift
//  ChatBot
//
//  Created by 김민규 on 2023/02/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ChatRoomManger {
	static func updateChatRoom(_ chatRoom: ChatRoom) {
		let db = Firestore.firestore()
		
		db.collection(FS.chatRooms.collectionName)
			.document(chatRoom.id)
			.setData([
				FS.chatRooms.lastChatField: chatRoom.lastChat,
				FS.chatRooms.usersField: chatRoom.userStringify(),
				FS.chatRooms.dateField: Date().timeIntervalSince1970,
			]) { error in
				guard error == nil else {
					print("Error Adding Chatroom, \(error!)")
					return
				}

//				print("Added ChatRoom")
			}
	}
	
	static func loadChatRooms(completionHandler: @escaping ([ChatRoom]) -> Void) {
		let db = Firestore.firestore()
		
		guard let currentUserEmail = Auth.auth().currentUser?.email else {
			print("Error: No User")
			return
		}
		
		let query = db.collection(FS.chatRooms.collectionName)
			.whereField(FS.chatRooms.usersField, arrayContains: currentUserEmail)
			.order(by: FS.chatRooms.dateField, descending: true)
			
		
		query.addSnapshotListener { snapshot, error in
			
			var chatRooms = [ChatRoom]()
			
			guard error == nil else {
				print("Failed to get documents from query \(FS.chatRooms.collectionName), \(error!)")
				return
			}
			
			guard let documents = snapshot?.documents else {
				print("Error loading chatroom list, snapshot is nil")
				return
			}
		
			
			
			for doc in documents {
				let data = doc.data()
				let docId = doc.documentID
				

				print(docId)
				
				guard let users = data[FS.chatRooms.usersField] as? [String],
					  let lastChat = data[FS.chatRooms.lastChatField] as? String
				else {
					print("Successfully Retrieved, but user field or lastChat field is empty")
					return
				}
				
				let typedUsers: [Sender] = users.map { user in
					switch user {
					case BotType.completionBot.rawValue:
						return Sender.bot(.completionBot)
					case BotType.editingBot.rawValue:
						return Sender.bot(.editingBot)
					case BotType.storyBot.rawValue:
						return Sender.bot(.storyBot)
					default:
						return Sender.user(user)
					}
				}
				
				let newChatRoom = ChatRoom(id: docId, participants: typedUsers, lastChat: lastChat)

				chatRooms.append(newChatRoom)
			}
			
			completionHandler(chatRooms)
			
		} // query.getDocuments
		
	}
}
