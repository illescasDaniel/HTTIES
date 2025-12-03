//
//  TopLevelDecoder.swift
//  HTTIES
//
//  Created by Daniel Illescas Romero on 3/12/25.
//

import Foundation

/// Simple protocol for top level decoders like `JSONDecoder`
public protocol DecodableDecoder {
	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

public extension EncodableBodyEncoder {
	func isValid(_ object: Any) -> Bool {
		return object is Encodable
	}
	func encode(_ object: Any) throws -> Data {
		if let encodable = object as? Encodable {
			return try self.encode(encodable)
		}
		// this won't likely be triggered, as HTTPURLRequest always checks isValid before calling this function
		fatalError("Attempted to encode a non-encodable object")
	}
}

extension JSONDecoder: DecodableDecoder {}
extension PropertyListDecoder: DecodableDecoder {}
