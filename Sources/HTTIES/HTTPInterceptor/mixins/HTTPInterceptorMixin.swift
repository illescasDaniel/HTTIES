import Foundation

public protocol HTTPInterceptorMixin: HTTPRequestInterceptorMixin, HTTPResponseInterceptorMixin {
	func sendRequestWithoutInterceptors(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse)
	func sendRequest(_ httpURLRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse)
}
extension HTTPInterceptorMixin {
	public func sendRequest(_ httpURLRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse) {
		var mutableRequest = httpURLRequest.urlRequest

		// Apply request interceptors
		try await self.applyInterceptors(toMutableRequest: &mutableRequest)

		// Execute the request
		var (data, response) = try await sendRequestWithoutInterceptors(mutableRequest)
		var error: Error? = nil

		// Apply response interceptors
		self.applyInterceptors(
			toData: &data, response: &response, error: &error,
			for: httpURLRequest.urlRequest
		)

		// If there was an error manipulated by interceptors, throw it
		if let error {
			throw error
		}

		return (data, response)
	}
}
