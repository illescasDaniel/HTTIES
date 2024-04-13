import Foundation
@testable import HTTIES

final class MockRequestInterceptor: HTTPRequestInterceptor {
	var mockRequest: URLRequest!

	func intercept(request: inout URLRequest) async throws {
		request = mockRequest
	}
}
