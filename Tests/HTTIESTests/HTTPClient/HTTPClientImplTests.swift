import XCTest
@testable import HTTIES

final class HTTPClientImplTests: XCTestCase {

	private var mockDataHandler: MockDataHandler!
	private var httpClient: HTTPClientImpl!

	override func setUp() {
		super.setUp()
		mockDataHandler = MockDataHandler()
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler, interceptors: [])
	}

	// Test a successful data request without interceptors
	func testSuccessfulDataRequest() async throws {
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let (data, response) = try await httpClient.data(for: testRequest)
		XCTAssertNotNil(data)
		XCTAssertEqual(response.statusCode, 200)
	}

	// Test a data request that throws an error
	func testDataRequestWithError() async throws {
		mockDataHandler.responseError = URLError(.badServerResponse)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		do {
			let _ = try await httpClient.data(for: testRequest)
			XCTFail("Expected failure did not occur")
		} catch {
			// Expected failure
		}
	}

	// Test a data request with interceptors
	func testDataRequestWithInterceptors() async throws {
		// Assuming MockInterceptor implementation from previous context
		let mockInterceptor = MockInterceptor()
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler, interceptors: [mockInterceptor])

		// Set up mock data handler for a successful response
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let (data, _) = try await httpClient.data(for: testRequest)
		XCTAssertNotNil(data)
		XCTAssertEqual(mockInterceptor.interceptedRequestURL, testRequest.urlRequest.url)
	}

	// Test decoding data into a Decodable object
	func testDataDecoding() async throws {
		mockDataHandler.responseData = "{\"property\": \"value\"}".data(using: .utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let decodedObject: MockCodable = try await httpClient.data(for: testRequest, decoding: MockCodable.self)
		XCTAssertEqual(decodedObject.property, "value")
	}

	// Test failing decoding data into a Decodable object
	func testFailingDataDecoding() async throws {
		mockDataHandler.responseData = "{\"property\": \"value\"}".data(using: .utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 400, httpVersion: nil, headerFields: nil)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		do {
			_ = try await httpClient.data(for: testRequest, decoding: MockCodable.self)
			XCTFail("It should throw")
		} catch {
			if case AppNetworkResponseError.unexpected(let statusCode) = error {
				XCTAssertEqual(statusCode, 400)
			} else {
				XCTFail("Unexpected error type: \(error)")
			}
		}
	}
}
