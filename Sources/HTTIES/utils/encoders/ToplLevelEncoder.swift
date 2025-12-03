//
//  ToplLevelEncoder.swift
//  HTTIES
//
//  Created by Daniel Illescas Romero on 3/12/25.
//

import Foundation

/// Simple protocol for any encoder. Example: `JSONEncoder`
public protocol TopLevelEncoder {
	func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: TopLevelEncoder {}
extension PropertyListEncoder: TopLevelEncoder {}
