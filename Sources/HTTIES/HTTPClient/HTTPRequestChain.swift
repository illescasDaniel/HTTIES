import Foundation

public final class HTTPRequestChain {
	private let nextRequest: (HTTPURLRequest) async throws -> (Data, HTTPURLResponse)
	public init(nextRequest: @escaping (HTTPURLRequest) async throws -> (Data, HTTPURLResponse)) {
		self.nextRequest = nextRequest
	}
	public func proceed(_ newRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse) {
		try await nextRequest(newRequest)
	}
}
