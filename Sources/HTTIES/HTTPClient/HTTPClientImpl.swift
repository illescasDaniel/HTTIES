import Foundation

public final class HTTPClientImpl: HTTPClient, HTTPInterceptorMixin {
	private let httpDataRequestHandler: any HTTPDataRequestHandler
	public var requestInterceptors: [any HTTPRequestInterceptor]
	public var responseInterceptors: [any HTTPResponseInterceptor]

	public init(
		httpDataRequestHandler: any HTTPDataRequestHandler,
		requestInterceptors: [any HTTPRequestInterceptor] = [],
		responseInterceptors: [any HTTPResponseInterceptor] = []
	) {
		self.httpDataRequestHandler = httpDataRequestHandler
		self.requestInterceptors = requestInterceptors
		self.responseInterceptors = responseInterceptors
	}

	public func sendRequestWithoutInterceptors(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse) {
		return try await httpDataRequestHandler.sendRequest(urlRequest)
	}
}
