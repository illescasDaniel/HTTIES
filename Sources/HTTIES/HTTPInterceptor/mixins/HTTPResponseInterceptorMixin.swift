import Foundation

public protocol HTTPResponseInterceptorMixin {
	var responseInterceptors: [any HTTPResponseInterceptor] { get }
	func applyInterceptors(data: Data, response: HTTPURLResponse, error: Error?, for urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse, Error?)
}
extension HTTPResponseInterceptorMixin {
	public func applyInterceptors(data: Data, response: HTTPURLResponse, error: Error?, for urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse, Error?) {
		var (data, response, error) = (data, response, error)
		for interceptor in responseInterceptors {
			(data, response, error) = try await interceptor.intercept(
				data: data,
				response: response,
				error: error,
				for: urlRequest
			)
		}
		return (data, response, error)
	}
}
