import Foundation
@testable import HTTIES

final class MockResponseInterceptor: HTTPResponseInterceptor {
	var mockData: Data!
	var mockResponse: HTTPURLResponse!
	var mockError: Error!

	func intercept(data: Data, response: HTTPURLResponse, error: Error?, for request: URLRequest) -> (Data, HTTPURLResponse, Error?) {
		return (mockData ?? data, mockResponse ?? response, mockError ?? error)
	}
}
