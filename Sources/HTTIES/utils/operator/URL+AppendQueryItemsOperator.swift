import Foundation

// Define a custom operator that doesn't conflict with existing operators
infix operator /? : AdditionPrecedence

public func /? (lhs: URL, rhs: [String: String?]) -> URL {
	return lhs.appendingQueryParameters(rhs) ?? lhs
}

public extension Optional where Wrapped == URL {
	static func /? (lhs: Optional<URL>, rhs: [String: String?]) -> URL? {
		return lhs?.appendingQueryParameters(rhs)
	}
}

public func /? (lhs: URL, rhs: [String: QueryParamValue]) -> URL {
	return lhs.appendingQueryParameters(rhs) ?? lhs
}

public extension Optional where Wrapped == URL {
	static func /? (lhs: Optional<URL>, rhs: [String: QueryParamValue]) -> URL? {
		return lhs?.appendingQueryParameters(rhs)
	}
}

// Extend URL to append query parameters
public extension URL {
	func appendingQueryParameters(_ parameters: [String: QueryParamValue]) -> URL? {
		return appendingQueryParameters(parameters.mapValues(\.stringValue))
	}
	func appendingQueryParameters(_ parameters: [String: String?]) -> URL? {
		guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			return nil
		}
		let queryItems = parameters.map { key, value in
			URLQueryItem(name: key, value: value)
		}.sorted { lhs, rhs in
			lhs.name < rhs.name
		}
		components.queryItems = (components.queryItems ?? []) + queryItems
		return components.url ?? nil
	}
}
