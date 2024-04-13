import Foundation

public protocol HTTPInterceptorMixin: HTTPRequestInterceptorMixin, HTTPResponseInterceptorMixin {
	func sendRequestWithoutInterceptors(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse)
	func sendRequest(_ httpURLRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse)
}
extension HTTPInterceptorMixin {
	public func sendRequest(_ httpURLRequest: HTTPURLRequest) async throws -> (Data, HTTPURLResponse) {
		// Apply request interceptors
		let request = try await self.applyInterceptors(request: httpURLRequest.urlRequest)

		// Execute the request
		let requestResult = try await sendRequestWithoutInterceptors(request)

		// Apply response interceptors
		let (data, response, error) = try await self.applyInterceptors(
			data: requestResult.0,
			response: requestResult.1,
			error: nil,
			for: httpURLRequest.urlRequest
		)

		// If there was an error manipulated by interceptors, throw it
		if let error {
			throw error
		}

		return (data, response)
	}
}
