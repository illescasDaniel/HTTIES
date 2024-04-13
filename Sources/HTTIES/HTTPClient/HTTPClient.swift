import Foundation

public protocol HTTPClient {
	func data(for httpRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse)
	
	func data<T: Decodable>(
		for httpRequest: HTTPURLRequest,
		decoding: T.Type
	) async throws -> T

	func data<T: Decodable>(
		for httpRequest: HTTPURLRequest,
		decoding: T.Type,
		jsonDecoder: JSONDecoder
	) async throws -> T
}

public extension HTTPClient {

	func data<T: Decodable>(
		for httpRequest: HTTPURLRequest,
		decoding: T.Type,
		jsonDecoder: JSONDecoder
	) async throws -> T {
		let (data, response) = try await self.data(for: httpRequest)
		if (200...299).contains(response.statusCode) {
			let value = try jsonDecoder.decode(T.self, from: data)
			return value
		} else {
			throw AppNetworkResponseError.unexpected(statusCode: response.statusCode)
		}
	}

	func data<T: Decodable>(
		for httpRequest: HTTPURLRequest,
		decoding: T.Type
	) async throws -> T {
		try await self.data(for: httpRequest, decoding: T.self, jsonDecoder: JSONDecoder())
	}
}
