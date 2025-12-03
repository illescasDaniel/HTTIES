import Foundation

public protocol HTTPDataRequestHandler: Sendable {
	func sendRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

public protocol URLSessionDataRequestHandler: HTTPDataRequestHandler {
	func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionDataRequestHandler {}

extension URLSessionDataRequestHandler {
	public func sendRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		let (data, response): (Data, URLResponse) = try await self.data(for: request, delegate: nil)
		guard let httpResponse = response as? HTTPURLResponse else {
			throw URLError(.cannotParseResponse)
		}
		return (data, httpResponse)
	}
}
