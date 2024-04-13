import XCTest
@testable import HTTIES

final class HTTPURLRequestTests: XCTestCase {

	// Test initializer with URL and default parameters
	func testInitWithURL() throws {
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let request = try HTTPURLRequest(url: url)

		XCTAssertEqual(request.urlRequest.url, url)
		XCTAssertEqual(request.urlRequest.httpMethod, "GET")
	}

	// Test initializer with URL, HTTP method, and headers
	func testInitWithURLHTTPMethodAndHeaders() throws {
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let headers = ["Content-Type": "application/json"]
		let request = try HTTPURLRequest(url: url, httpMethod: .post, headers: headers)

		XCTAssertEqual(request.urlRequest.url, url)
		XCTAssertEqual(request.urlRequest.httpMethod, "POST")
		XCTAssertEqual(request.urlRequest.allHTTPHeaderFields, headers)
	}

	// Test initializer with invalid URL scheme
	func testInitWithInvalidURLScheme() throws {
		let url = try XCTUnwrap(URL(string: "ftp://example.com"))

		XCTAssertThrowsError(try HTTPURLRequest(url: url)) { error in
			XCTAssertTrue(error is AppNetworkRequestError)
			if case AppNetworkRequestError.invalidScheme(let scheme) = error {
				XCTAssertEqual(scheme, "ftp")
			} else {
				XCTFail("Expected AppNetworkRequestError.invalidScheme error")
			}
		}
	}

	// Test initializer with URL and query items
	func testInitWithURLAndQueryItems() throws {
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let queryItems = [URLQueryItem(name: "q", value: "search")]

		let request = try HTTPURLRequest(url: url, queryItems: queryItems)
		let components = URLComponents(url: try XCTUnwrap(request.urlRequest.url), resolvingAgainstBaseURL: true)

		XCTAssertEqual(components?.queryItems, queryItems)
	}

	// Test initializer with URL and body dictionary
	func testInitWithURLAndBodyDictionary() throws {
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let body = ["key": "value"]
		let request = try HTTPURLRequest(url: url, bodyDictionary: body)

		let data = request.urlRequest.httpBody
		XCTAssertNotNil(data)

		let decodedBody = try JSONSerialization.jsonObject(with: try XCTUnwrap(data), options: []) as? [String: String]
		XCTAssertEqual(decodedBody, body)
	}

	// Test initializer with URL and invalid body dictionary
	func testInitWithURLAndInvalidBodyDictionary() throws {
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let body = ["key": Date()] // Using Date which is not a valid JSON object

		XCTAssertThrowsError(try HTTPURLRequest(url: url, bodyDictionary: body)) { error in
			XCTAssertTrue(error is AppNetworkRequestError)
			if case AppNetworkRequestError.invalidJSONObject(let jsonObject) = error {
				XCTAssertNotNil(jsonObject["key"] as? Date)
			} else {
				XCTFail("Expected AppNetworkRequestError.invalidJSONObject error")
			}
		}
	}

	// Test initializer with URL and encodable body
	func testInitWithURLAndEncodableBody() throws {
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let mockEncodable = MockCodable(property: "value")
		let request = try HTTPURLRequest(url: url, bodyEncodable: mockEncodable)

		let data = request.urlRequest.httpBody
		XCTAssertNotNil(data)

		let decoder = JSONDecoder()
		let decodedObject = try decoder.decode(MockCodable.self, from: try XCTUnwrap(data))
		XCTAssertEqual(decodedObject, mockEncodable)
	}
}
