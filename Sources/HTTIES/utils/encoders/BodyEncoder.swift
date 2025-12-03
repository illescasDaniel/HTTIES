//
//  BodyEncoder.swift
//  HTTIES
//
//  Created by Daniel Illescas Romero on 3/12/25.
//

import Foundation

/// This protocol is meant for encoding a request body.
/// The input object could be anything, like an encodable object, an array or a dictionary.
/// Common structures conforming to this protocol include another protocol like `TopLevelBodyEncoder` (which includes `JSONEncoder`) and
/// `JSONDictionaryEncoder`, based on `JSONSerialization`
public protocol BodyEncoder {
	func isValid(_ object: Any) -> Bool
	func encode(_ object: Any) throws -> Data
}
