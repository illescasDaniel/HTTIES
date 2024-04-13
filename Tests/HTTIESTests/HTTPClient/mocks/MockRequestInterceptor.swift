import Foundation
@testable import HTTIES

final class MockRequestInterceptor: HTTPInoutRequestInterceptor {
	var mockRequest: URLRequest!

	func intercept(request: inout URLRequest) async throws {
		request = mockRequest
	}
}
