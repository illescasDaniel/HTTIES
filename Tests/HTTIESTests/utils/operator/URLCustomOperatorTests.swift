import XCTest
@testable import HTTIES

class URLCustomOperatorsTests: XCTestCase {

	func testAppendingPathToStringURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
		let fullURL = baseURL / "path"
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/path")
	}

	func testAppendingPathComponentToIntURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
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

	func testAppendingCustomStringConvertibleToURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
		let customValue = CustomStringConvertibleMock(value: "custom")
		let fullURL = baseURL / customValue
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/custom")
	}

	func testAppendingLiteralQueryParametersToURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
		let valueFromVariable = "asdf asdf"
		let fullURL = baseURL /? ["param": "value", "other": 2, "param2": true, "enabled": nil, "items": [4,2,3,4.4,"hi"], "zzz": .value(valueFromVariable)]
		let sortedQueryItems = try XCTUnwrap(URLComponents(string: fullURL.absoluteString)?.queryItems?.sorted(by: { $0.name < $1.name }))
		XCTAssertEqual(sortedQueryItems, [
			.init(name: "enabled", value: nil),
			.init(name: "items", value: "4,2,3,4.4,hi"),
			.init(name: "other", value: "2"),
			.init(name: "param", value: "value"),
			.init(name: "param2", value: "1"),
			.init(name: "zzz", value: "asdf asdf")
		])
		XCTAssertEqual(fullURL.absoluteString, "https://example.com?enabled&items=4,2,3,4.4,hi&other=2&param=value&param2=1&zzz=asdf%20asdf")
	}

	func testAppendingLiteralVarQueryParametersToURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
		let valueFromVariable = "asdf asdf"
		let fullURL = baseURL /? ["param": .value("value"), "other": .value(2), "param2": .value(true), "enabled": nil, "items": .value([4,2,3,4.4,"hi"]),
								  "zzz": .value(valueFromVariable), "ab": .value(CustomStringConvertibleMock(value: "a")),
								  "code": .value(StatusCode.ok), "path": .value(PathComponent.about)]
		let sortedQueryItems = try XCTUnwrap(URLComponents(string: fullURL.absoluteString)?.queryItems?.sorted(by: { $0.name < $1.name }))
		XCTAssertEqual(sortedQueryItems, [
			.init(name: "ab", value: "a"),
			.init(name: "code", value: "200"),
			.init(name: "enabled", value: nil),
			.init(name: "items", value: "4,2,3,4.4,hi"),
			.init(name: "other", value: "2"),
			.init(name: "param", value: "value"),
			.init(name: "param2", value: "1"),
			.init(name: "path", value: "about"),
			.init(name: "zzz", value: "asdf asdf")
		])
		XCTAssertEqual(fullURL.absoluteString, "https://example.com?ab=a&code=200&enabled&items=4,2,3,4.4,hi&other=2&param=value&param2=1&path=about&zzz=asdf%20asdf")
	}

	func testAppendingLiteralQueryParametersToOptionalURL() throws {
		let baseURL: URL? = URL(string: "https://example.com")
		let fullURL = try XCTUnwrap(baseURL /? ["param": "value", "other": 2, "param2": true, "enabled": nil])
		let sortedQueryItems = try XCTUnwrap(URLComponents(string: fullURL.absoluteString)?.queryItems?.sorted(by: { $0.name < $1.name }))
		XCTAssertEqual(sortedQueryItems, [
			.init(name: "enabled", value: nil),
			.init(name: "other", value: "2"),
			.init(name: "param", value: "value"),
			.init(name: "param2", value: "1")
		])
		XCTAssertEqual(fullURL.absoluteString, "https://example.com?enabled&other=2&param=value&param2=1")
	}

	func testAppendingMixedQueryParametersToURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
		let valueFromVariable = "true"
		// when using values from variables (non literals) in the values field, we must use strings for all parameters
		let fullURL = baseURL /? ["param": "value", "other": "2", "param2": valueFromVariable, "enabled": nil]
		let sortedQueryItems = try XCTUnwrap(URLComponents(string: fullURL.absoluteString)?.queryItems?.sorted(by: { $0.name < $1.name }))
		XCTAssertEqual(sortedQueryItems, [
			.init(name: "enabled", value: nil),
			.init(name: "other", value: "2"),
			.init(name: "param", value: "value"),
			.init(name: "param2", value: "true")
		])
		XCTAssertEqual(fullURL.absoluteString, "https://example.com?enabled&other=2&param=value&param2=true")
	}

	func testAppendingQueryParametersToOptionalURL() throws {
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

	func testAppendingEnumToURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
		let fullURL = baseURL / PathComponent.contact
		XCTAssertEqual(fullURL.absoluteString, "https://example.com/contact")
	}

	func testAppendingIntEnumToURL() throws {
		let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
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
