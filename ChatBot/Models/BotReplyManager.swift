//
//  BotReplyManager.swift
//  ChatBot
//
//  Created by 김민규 on 2023/02/21.
//

import Foundation
import Alamofire

class BotReplyManager {
	
	
	func getStoryReply(completionHandler: @escaping (Story) -> Void) {
		let storyURL = "https://shortstories-api.onrender.com"
		AF.request(storyURL)
			.responseDecodable(of: StoryData.self) { response in
				switch response.result {
				case .success(let data):
					guard let title = data.title,
						  let story = data.story else {
						print("Error: Title or story is nil")
						return
					}
					
					let storyObject = Story(story: story, title: title)
					completionHandler(storyObject)
					
				case .failure(let error):
					print(error)
				} // switch response.result
			}
	} // get story data
	
	
	func getCompletionReply(question: String = "Say this is test", completionHandler: @escaping (String) -> Void) {
		let completionURL = "https://api.openai.com/v1/completions"
		
		let headers: HTTPHeaders = [
			"Content-Type": "application/json",
			"Authorization": "Bearer \(APIKeys.openAI)"
		]
		
		let parameters: [String: Any] = [
			"model": "ada",
			"prompt": "\(question)",
			"temperature": 0,
			"max_tokens": 5
		]
		
		AF.request(completionURL,
				   method: .post,
				   parameters: parameters,
				   encoding: JSONEncoding.default,
				   headers: headers
		).responseDecodable(of: CompletionData.self) { response in
			switch response.result {
			case .success(let data):
				print(data)
				guard let answer = data.choices?.first?.text else { return }
				
				completionHandler(answer)
				
			case .failure(let error):
				print(error)
			} // switch
		}
		
		
	} // getCompletionReply
	
	func getEditingReply(text2Edit: String, completionHandler: @escaping (String) -> Void) {
		let editingURL = "https://api.openai.com/v1/edits"
		
		let headers: HTTPHeaders = [
			"Content-Type": "application/json",
			"Authorization": "Bearer \(APIKeys.openAI)"
		]
		
		let parameters: [String: Any] = [
			"model": "text-davinci-edit-001",
			"input": "\(text2Edit)",
			"instruction": "Fix the spelling mistakes"
		]
		
		AF.request(editingURL,
				   method: .post,
				   parameters: parameters,
				   encoding: JSONEncoding.default,
				   headers: headers
		).responseDecodable(of: EditingData.self) { response in
			switch response.result {
			case .success(let data):
				print(data)
				guard let answer = data.choices?.first?.text else { return }
				
				completionHandler(answer)
				
			case .failure(let error):
				print(error)
			} // switch
		}
	} // getEditingReply
	
	
	
	
}

