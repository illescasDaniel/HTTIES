//
//  TopLevelDecoder.swift
//  HTTIES
//
//  Created by Daniel Illescas Romero on 3/12/25.
//

import Foundation

public protocol TopLevelDecoder {
	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: TopLevelDecoder {}
extension PropertyListDecoder: TopLevelDecoder {}
