// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let completionData = try? JSONDecoder().decode(CompletionData.self, from: jsonData)

import Foundation

// MARK: - CompletionData
struct CompletionData: Codable {
	let id, object: String?
	let created: Int?
	let model: String?
	let choices: [Choice]?
	let usage: Usage?
}

// MARK: - Choice
struct Choice: Codable {
	let text: String?
	let index: Int?
	let logprobs: JSONNull?
	let finishReason: String?

	enum CodingKeys: String, CodingKey {
		case text, index, logprobs
		case finishReason
	}
}

// MARK: - Usage
struct Usage: Codable {
	let promptTokens, completionTokens, totalTokens: Int?

	enum CodingKeys: String, CodingKey {
		case promptTokens
		case completionTokens
		case totalTokens
	}
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
		return true
	}

	public var hashValue: Int {
		return 0
	}

	public init() {}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if !container.decodeNil() {
			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}

