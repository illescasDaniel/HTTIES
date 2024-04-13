import Foundation

public final class HTTPRequestChain {
	private let nextRequest: (HTTPURLRequest) async throws -> (Data, HTTPURLResponse)
	init(nextRequest: @escaping (HTTPURLRequest) async throws -> (Data, HTTPURLResponse)) {
		self.nextRequest = nextRequest
	}
	func proceed(_ newRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse) {
		try await nextRequest(newRequest)
	}
}
