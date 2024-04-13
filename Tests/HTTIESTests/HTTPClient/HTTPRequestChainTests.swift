import XCTest
@testable import HTTIES

final class HTTPRequestChainTests: XCTestCase {

	func testProceedWithValidRequest() async throws {
		// Setup a mock nextRequest function that simulates a network call
		let expectedData = Data("expected response".utf8)
		let expectedResponse = try XCTUnwrap(HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil))

		let requestChain = HTTPRequestChain { _ in return (expectedData, expectedResponse) }

		let testRequest = try HTTPURLRequest(url: URL(string: "https://example.com")!)
		let (data, response) = try await requestChain.proceed(testRequest)

		XCTAssertEqual(data, expectedData)
		XCTAssertEqual(response.statusCode, 200)
	}

	func testProceedWithInvalidRequest() async throws {
		// Setup to simulate an error
		let requestChain = HTTPRequestChain { _ in
			throw URLError(.badURL)
		}

		let testRequest = try HTTPURLRequest(url: URL(string: "https://example.com")!)

		do {
			let _ = try await requestChain.proceed(testRequest)
			XCTFail("Should have thrown an error for an invalid request")
		} catch {
			// Expected failure
		}
	}
}
