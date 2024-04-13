import Foundation

public final class HTTPClientImpl: HTTPClient {

	private let httpDataRequestHandler: any HTTPDataRequestHandler
	private let interceptors: [any HTTPInterceptor]

	public init(httpDataRequestHandler: any HTTPDataRequestHandler, interceptors: [any HTTPInterceptor] = []) {
		self.httpDataRequestHandler = httpDataRequestHandler
		self.interceptors = interceptors
	}

	public func data(for httpRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse) {
		var requestChain = HTTPRequestChain { request in
			let (data, response) = try await self.httpDataRequestHandler.data(for: request.urlRequest)
			guard let httpResponse = response as? HTTPURLResponse else {
				throw URLError(.cannotParseResponse)
			}
			return (data, httpResponse)
		}

		var lastResponse: (Data, HTTPURLResponse)?
		for interceptor in interceptors {
			let response = try await interceptor.data(for: httpRequest, httpRequestChain: requestChain)
			lastResponse = response
			requestChain = HTTPRequestChain { _ in response }
		}

		if let lastResponse {
			return lastResponse
		}
		return try await requestChain.proceed(httpRequest)
	}
}
