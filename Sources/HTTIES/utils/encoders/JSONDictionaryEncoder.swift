//
//  JSONDictionaryEncoder 2.swift
//  HTTIES
//
//  Created by Daniel Illescas Romero on 3/12/25.
//

import Foundation

public struct JSONDictionaryEncoder: BodyEncoder {

	public let options: JSONSerialization.WritingOptions

	public init(options: JSONSerialization.WritingOptions = []) {
		self.options = options
	}

	public func isValid(_ object: Any) -> Bool {
		return JSONSerialization.isValidJSONObject(object)
	}

	public func encode(_ object: Any) throws -> Data {
		return try JSONSerialization.data(withJSONObject: object, options: options)
	}
}
