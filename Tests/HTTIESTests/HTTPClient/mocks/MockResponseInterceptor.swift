import Foundation
@testable import HTTIES

final class MockResponseInterceptor: HTTPResponseInterceptor {
	var mockData: Data?
	var mockResponse: HTTPURLResponse?
	var mockError: Error?

	func intercept(data: inout Data, response: inout HTTPURLResponse, error: inout Error?, for request: URLRequest) {
		if let mockData {
			data = mockData
		}
		if let mockResponse {
			response = mockResponse
		}
		if let mockError {
			error = mockError
		}
	}
}
