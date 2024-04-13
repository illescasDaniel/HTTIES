import XCTest
@testable import HTTIES

final class MockDataHandler: HTTPDataRequestHandler {

	var responseData: Data?
	var response: HTTPURLResponse?
	var responseError: Error?

	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
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
