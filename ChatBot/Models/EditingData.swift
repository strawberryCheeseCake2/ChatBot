// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let editingData = try? JSONDecoder().decode(EditingData.self, from: jsonData)

import Foundation

// MARK: - EditingData
struct EditingData: Codable {
	let object: String?
	let created: Int?
	let choices: [Choice]?
	let usage: Usage?
}



