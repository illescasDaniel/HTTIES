import Foundation

public protocol HTTPClient: Sendable {
	func sendRequest(_ httpURLRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse)

	func sendRequest<T: Decodable>(
		_ httpURLRequest: HTTPURLRequest,
		decoding: T.Type,
		decoder: any DecodableDecoder
	) async throws -> T
}

public extension HTTPClient {
	func sendRequest<T: Decodable>(
		_ httpURLRequest: HTTPURLRequest,
		decoding: T.Type,
		decoder: any DecodableDecoder
	) async throws -> T {
		let (data, response) = try await self.sendRequest(httpURLRequest)
		if (200...299).contains(response.statusCode) {
			let value = try decoder.decode(T.self, from: data)
			return value
		} else {
			throw AppNetworkResponseError.unexpected(statusCode: response.statusCode)
		}
	}
}
