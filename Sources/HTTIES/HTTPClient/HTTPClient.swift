import Foundation

public protocol HTTPClient {
	func sendRequest(_ httpURLRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse)

	func sendRequest<T: Decodable>(
		_ httpURLRequest: HTTPURLRequest,
		decoding: T.Type
	) async throws -> T

	func sendRequest<T: Decodable>(
		_ httpURLRequest: HTTPURLRequest,
		decoding: T.Type,
		jsonDecoder: JSONDecoder
	) async throws -> T
}

public extension HTTPClient {

	func sendRequest<T: Decodable>(
		_ httpURLRequest: HTTPURLRequest,
		decoding: T.Type
	) async throws -> T {
		try await self.sendRequest(httpURLRequest, decoding: T.self, jsonDecoder: JSONDecoder())
	}

	func sendRequest<T: Decodable>(
		_ httpURLRequest: HTTPURLRequest,
		decoding: T.Type,
		jsonDecoder: JSONDecoder
	) async throws -> T {
		let (data, response) = try await self.sendRequest(httpURLRequest)
		if (200...299).contains(response.statusCode) {
			let value = try jsonDecoder.decode(T.self, from: data)
			return value
		} else {
			throw AppNetworkResponseError.unexpected(statusCode: response.statusCode)
		}
	}

}
