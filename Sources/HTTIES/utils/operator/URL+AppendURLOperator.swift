import Foundation

public func / (lhs: URL, rhs: String) -> URL {
	if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
		return lhs.appending(path: rhs)
	}
	return lhs.appendingPathComponent(rhs)
}

public func / (lhs: URL, rhs: Int) -> URL {
	return lhs / "\(rhs)"
}


public func / (lhs: Optional<URL>, rhs: String) -> URL? {
	guard let lhs else { return nil }
	if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
		return lhs.appending(path: rhs)
	}
	return lhs.appendingPathComponent(rhs)
}

public func / (lhs: Optional<URL>, rhs: Int) -> URL? {
	return lhs / "\(rhs)"
}

// Extend the operator to handle any CustomStringConvertible type
public func / <T: CustomStringConvertible>(lhs: URL, rhs: T) -> URL {
	return lhs / String(describing: rhs)
}

public func / <T: CustomStringConvertible>(lhs: Optional<URL>, rhs: T) -> URL? {
	return lhs / String(describing: rhs)
}

public func / <T: RawRepresentable>(lhs: URL, rhs: T) -> URL where T.RawValue: CustomStringConvertible {
	return lhs / String(describing: rhs.rawValue)
}

public func / <T: RawRepresentable>(lhs: Optional<URL>, rhs: T) -> URL? where T.RawValue: CustomStringConvertible {
	return lhs / String(describing: rhs.rawValue)
}
