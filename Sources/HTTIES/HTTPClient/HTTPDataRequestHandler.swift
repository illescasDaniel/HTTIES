import Foundation

public protocol HTTPDataRequestHandler {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPDataRequestHandler {}
