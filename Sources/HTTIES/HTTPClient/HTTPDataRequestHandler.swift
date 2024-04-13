import Foundation

public protocol HTTPDataRequestHandler {
	func sendRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

extension URLSession: HTTPDataRequestHandler {
	public func sendRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		let (data, response): (Data, URLResponse) = try await self.data(for: request, delegate: nil)
		guard let httpResponse = response as? HTTPURLResponse else {
			throw URLError(.cannotParseResponse)
		}
		return (data, httpResponse)
	}
}
