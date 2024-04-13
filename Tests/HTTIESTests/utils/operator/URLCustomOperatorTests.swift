import XCTest
@testable import HTTIES

class URLCustomOperatorsTests: XCTestCase {

	func testAppendingPathToStringURL() {
		let baseURL = URL(string: "https://example.com")!
		let fullURL = baseURL / "path"
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/path")
	}

	func testAppendingPathComponentToIntURL() {
		let baseURL = URL(string: "https://example.com")!
		let fullURL = baseURL / 123
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/123")
	}

	func testAppendingPathToStringToOptionalURL() {
		let baseURL: URL? = URL(string: "https://example.com")
		let fullURL = baseURL / "path"
		XCTAssertEqual(fullURL?.absoluteString, "https://example.com/path")
	}

	func testAppendingPathComponentToIntToOptionalURL() {
		let baseURL: URL? = URL(string: "https://example.com")
		let fullURL = baseURL / 123
		XCTAssertEqual(fullURL?.absoluteString, "https://example.com/123")
	}

	func testAppendingCustomStringConvertibleToURL() {
		let baseURL = URL(string: "https://example.com")!
		let customValue = CustomStringConvertibleMock(value: "custom")
		let fullURL = baseURL / customValue
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/custom")
	}

	func testAppendingQueryParametersToURL() throws {
		let baseURL = URL(string: "https://example.com")!
		let fullURL = baseURL /? ["param": "value", "other": "value2"]
		let sortedQueryItems = try XCTUnwrap(URLComponents(string: fullURL.absoluteString)?.queryItems?.sorted(by: { $0.name < $1.name }))
		XCTAssertEqual(sortedQueryItems, [.init(name: "other", value: "value2"), .init(name: "param", value: "value")])
	}

	func testAppendingQueryParametersToOptionalURL() {
		let baseURL: URL? = URL(string: "https://example.com")
		let fullURL = baseURL /? ["param": "value"]
		XCTAssertEqual(fullURL?.absoluteString, "https://example.com?param=value")
	}

	func testAppendingCustomStringConvertibleToOptionalURL() {
		let customValue = CustomStringConvertibleMock(value: "customPath")
		let baseURL: URL? = URL(string: "https://example.com")
		let fullURL = baseURL / customValue
		XCTAssertEqual(fullURL?.absoluteString, "https://example.com/customPath")

		let nilURL: URL? = nil
		let nilFullURL = nilURL / customValue
		XCTAssertNil(nilFullURL)
	}

	func testAppendingEnumToURL() {
		let baseURL = URL(string: "https://example.com")!
		let fullURL = baseURL / PathComponent.contact
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/contact")
	}

	func testAppendingIntEnumToURL() {
		let baseURL = URL(string: "https://example.com")!
		let fullURL = baseURL / StatusCode.notFound
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/404")
	}

	func testAppendingEnumToOptionalURL() {
		let baseURL: URL? = URL(string: "https://example.com")
		let fullURL = baseURL / PathComponent.help
		XCTAssertEqual(fullURL?.absoluteString, "https://example.com/help")
	}

	func testAppendingIntEnumToOptionalURL() {
		let baseURL: URL? = URL(string: "https://example.com")
		let fullURL = baseURL / StatusCode.ok
		XCTAssertEqual(fullURL?.absoluteString, "https://example.com/200")
	}
}
