//
//  Message.swift
//  RC_W5
//
//  Created by 김민규 on 2023/02/19.
//

import Foundation



struct Message {
	var id = UUID().uuidString
	let sender: Sender
	let body: String
	var date = Date().timeIntervalSince1970
	
	init(sender: Sender, body: String) {
		self.sender = sender
		self.body = body
	}
	
	init(sender: Sender, body: String, date: TimeInterval, id: String) {
		self.sender = sender
		self.body = body
		self.date = date
		self.id = id
	}
}
