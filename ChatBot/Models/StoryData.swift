// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let storyData = try? JSONDecoder().decode(StoryData.self, from: jsonData)

import Foundation

// MARK: - StoryData
struct StoryData: Codable {
	let id, title, author, story: String?
	let moral: String?

	enum CodingKeys: String, CodingKey {
		case id
		case title, author, story, moral
	}
}
