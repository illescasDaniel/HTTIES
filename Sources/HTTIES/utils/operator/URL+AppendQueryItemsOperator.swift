import Foundation

// Define a custom operator that doesn't conflict with existing operators
infix operator /? : AdditionPrecedence

public func /? (lhs: URL, rhs: [String: String?]) -> URL {
	return lhs.appendingQueryParameters(rhs)
}

public extension Optional where Wrapped == URL {
	static func /? (lhs: Optional<URL>, rhs: [String: String?]) -> URL? {
		return lhs?.appendingQueryParameters(rhs)
	}
}

public func /? (lhs: URL, rhs: [String: QueryParamValue]) -> URL {
	return lhs.appendingQueryParameters(rhs)
}

public extension Optional where Wrapped == URL {
	static func /? (lhs: Optional<URL>, rhs: [String: QueryParamValue]) -> URL? {
		return lhs?.appendingQueryParameters(rhs)
	}
}

// Extend URL to append query parameters
fileprivate extension URL {
	func appendingQueryParameters(_ parameters: [String: QueryParamValue]) -> URL {
		return appendingQueryParameters(parameters.mapValues(\.stringValue))
	}
	func appendingQueryParameters(_ parameters: [String: String?]) -> URL {
		guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			return self
		}
		let queryItems = parameters.map { key, value in
			URLQueryItem(name: key, value: value)
		}
		let allQueryItems = ((components.queryItems ?? []) + queryItems).sorted { lhs, rhs in
			lhs.name < rhs.name
		}
		components.queryItems = allQueryItems
		return components.url ?? self
	}
}
