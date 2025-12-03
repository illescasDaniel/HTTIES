//
//  ToplLevelEncoder.swift
//  HTTIES
//
//  Created by Daniel Illescas Romero on 3/12/25.
//

import Foundation

/// Simple protocol for top level encoders like `JSONEncoder`
public protocol EncodableBodyEncoder: BodyEncoder {
	func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: EncodableBodyEncoder {}
extension PropertyListEncoder: EncodableBodyEncoder {}
