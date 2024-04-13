import XCTest
@testable import HTTIES

final class MockDataHandler: HTTPDataRequestHandler {

	var request: URLRequest?

	var responseData: Data?
	var response: HTTPURLResponse?
	var responseError: Error?

	func sendRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		self.request = request
		if let responseError = responseError {
			throw responseError
		}
		guard let response = response else {
			throw URLError(.cannotParseResponse)
		}
		guard let responseData = responseData else {
			throw URLError(.badServerResponse)
		}
		return (responseData, response)
	}
}
