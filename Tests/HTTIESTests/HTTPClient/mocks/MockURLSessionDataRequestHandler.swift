import Foundation
@testable import HTTIES

final class MockURLSessionDataRequestHandler: URLSessionDataRequestHandler {
	var result: (Data, URLResponse)!

	func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
		return result
	}
}
