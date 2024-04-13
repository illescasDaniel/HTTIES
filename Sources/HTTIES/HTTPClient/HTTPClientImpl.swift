import Foundation

public protocol HTTPRequestInterceptor {
	func intercept(request: inout URLRequest) async throws
}

public protocol HTTPResponseInterceptor {
	func intercept(data: Data, response: HTTPURLResponse, error: Error?, for request: URLRequest) -> (Data, HTTPURLResponse, Error?)
}

public final class HTTPClientImpl: HTTPClient {
	private let httpDataRequestHandler: any HTTPDataRequestHandler
	private var requestInterceptors: [any HTTPRequestInterceptor] = []
	private var responseInterceptors: [any HTTPResponseInterceptor] = []
	internal var currentRequest: URLRequest?

	public init(
		httpDataRequestHandler: any HTTPDataRequestHandler,
		requestInterceptors: [any HTTPRequestInterceptor] = [],
		responseInterceptors: [any HTTPResponseInterceptor] = []
	) {
		self.httpDataRequestHandler = httpDataRequestHandler
		self.requestInterceptors = requestInterceptors
		self.responseInterceptors = responseInterceptors
	}

	public func addRequestInterceptor(_ interceptor: any HTTPRequestInterceptor) {
		requestInterceptors.append(interceptor)
	}

	public func addResponseInterceptor(_ interceptor: any HTTPResponseInterceptor) {
		responseInterceptors.append(interceptor)
	}

	public func sendRequest(_ httpURLRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse) {
		var mutableRequest = httpURLRequest.urlRequest

		// Apply request interceptors
		for interceptor in requestInterceptors {
			try await interceptor.intercept(request: &mutableRequest)
		}
		currentRequest = mutableRequest

		// Execute the request
		let (data, response) = try await httpDataRequestHandler.data(for: mutableRequest)
		guard let httpResponse = response as? HTTPURLResponse else {
			throw URLError(.cannotParseResponse)
		}

		var interceptedData = data
		var interceptedResponse = httpResponse
		var interceptedError: Error? = nil

		// Apply response interceptors
		for interceptor in responseInterceptors {
			let result = interceptor.intercept(
				data: interceptedData,
				response: interceptedResponse,
				error: interceptedError,
				for: httpURLRequest.urlRequest
			)
			interceptedData = result.0
			interceptedResponse = result.1
			interceptedError = result.2
		}

		// If there was an error manipulated by interceptors, throw it
		if let error = interceptedError {
			throw error
		}

		return (interceptedData, interceptedResponse)
	}
}
