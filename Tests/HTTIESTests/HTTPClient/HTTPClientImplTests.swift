import XCTest
@testable import HTTIES

final class HTTPClientImplTests: XCTestCase {

	private var mockDataHandler: MockDataHandler!
	private var httpClient: HTTPClientImpl!

	override func setUp() {
		super.setUp()
		mockDataHandler = MockDataHandler()
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler)
	}

	override func tearDown() {
		super.tearDown()
		mockDataHandler = nil
		httpClient = nil
	}

	// Test a successful data request without interceptors
	func testSuccessfulDataRequest() async throws {
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let (data, response) = try await httpClient.sendRequest(testRequest)
		XCTAssertNotNil(data)
		XCTAssertEqual(response.statusCode, 200)
	}

	// Test a data request that throws an error
	func testDataRequestWithError() async throws {
		mockDataHandler.responseError = URLError(.badServerResponse)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		do {
			let _ = try await httpClient.sendRequest(testRequest)
			XCTFail("Expected failure did not occur")
		} catch {
			// Expected failure
		}
	}

	// Test a data request with interceptor
	func testDataRequestWithRequestInterceptor() async throws {
		// Set up mock data handler for a successful response
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		// Assuming MockInterceptor implementation from previous context
		let mockInterceptor = MockRequestInterceptor()
		mockInterceptor.mockRequest = URLRequest(url: try XCTUnwrap(URL(string: "https://example2.com")))
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler, requestInterceptors: [mockInterceptor])

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let (data, _) = try await httpClient.sendRequest(testRequest)
		XCTAssertNotNil(data)
		XCTAssertEqual(mockInterceptor.mockRequest, mockDataHandler.request)
		XCTAssertNotEqual(mockInterceptor.mockRequest, testRequest.urlRequest)
	}

	// Test a data request with added interceptor
	func testDataRequestWithAddedRequestInterceptor() async throws {
		// Set up mock data handler for a successful response
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		// Assuming MockInterceptor implementation from previous context
		let mockInterceptor = MockRequestInterceptor()
		mockInterceptor.mockRequest = URLRequest(url: try XCTUnwrap(URL(string: "https://example2.com")))
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler)
		httpClient.requestInterceptors.append(mockInterceptor)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let (data, _) = try await httpClient.sendRequest(testRequest)
		XCTAssertNotNil(data)
		XCTAssertEqual(mockInterceptor.mockRequest, mockDataHandler.request)
		XCTAssertNotEqual(mockInterceptor.mockRequest, testRequest.urlRequest)
	}

	func testDataRequestWithResponseInterceptor() async throws {
		// Set up mock data handler for a successful response
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		// Assuming MockInterceptor implementation from previous context
		let mockInterceptor = MockResponseInterceptor()
		mockInterceptor.mockData = Data([1])
		mockInterceptor.mockResponse = try XCTUnwrap(HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example2.com")), statusCode: 400, httpVersion: nil, headerFields: nil))
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler, responseInterceptors: [mockInterceptor])

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let (data, response) = try await httpClient.sendRequest(testRequest)
		XCTAssertEqual(mockInterceptor.mockData, data)
		XCTAssertEqual(mockInterceptor.mockResponse, response)
		XCTAssertNotEqual(mockInterceptor.mockData, mockDataHandler.responseData)
		XCTAssertNotEqual(mockInterceptor.mockResponse, mockDataHandler.response)
	}

	func testDataRequestWithAddedResponseInterceptor() async throws {
		// Set up mock data handler for a successful response
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		// Assuming MockInterceptor implementation from previous context
		let mockInterceptor = MockResponseInterceptor()
		mockInterceptor.mockData = Data([1])
		mockInterceptor.mockResponse = try XCTUnwrap(HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example2.com")), statusCode: 400, httpVersion: nil, headerFields: nil))
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler)
		httpClient.responseInterceptors.append(mockInterceptor)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let (data, response) = try await httpClient.sendRequest(testRequest)
		XCTAssertEqual(mockInterceptor.mockData, data)
		XCTAssertEqual(mockInterceptor.mockResponse, response)
		XCTAssertNotEqual(mockInterceptor.mockData, mockDataHandler.responseData)
		XCTAssertNotEqual(mockInterceptor.mockResponse, mockDataHandler.response)
	}

	func testDataRequestWithResponseErrorInterceptor() async throws {
		// Set up mock data handler for a successful response
		mockDataHandler.responseData = Data("mock response".utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		// Assuming MockInterceptor implementation from previous context
		let mockInterceptor = MockResponseInterceptor()
		mockInterceptor.mockError = URLError(.badServerResponse)
		httpClient = HTTPClientImpl(httpDataRequestHandler: mockDataHandler, responseInterceptors: [mockInterceptor])

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))

		do {
			_ = try await httpClient.sendRequest(testRequest)
			XCTFail()
		} catch {
			XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
		}
	}

	// Test decoding data into a Decodable object
	func testDataDecoding() async throws {
		mockDataHandler.responseData = Data(#"{"property": "value"}"#.utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 200, httpVersion: nil, headerFields: nil)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		let decodedObject: MockCodable = try await httpClient.sendRequest(testRequest, decoding: MockCodable.self)
		XCTAssertEqual(decodedObject.property, "value")
	}

	// Test failing decoding data into a Decodable object
	func testFailingDataDecoding() async throws {
		mockDataHandler.responseData = Data(#"{"property": "value"}"#.utf8)
		mockDataHandler.response = HTTPURLResponse(url: try XCTUnwrap(URL(string: "https://example.com")), statusCode: 400, httpVersion: nil, headerFields: nil)

		let testRequest = try HTTPURLRequest(url: try XCTUnwrap(URL(string: "https://example.com")))
		do {
			_ = try await httpClient.sendRequest(testRequest, decoding: MockCodable.self)
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
