import Foundation

public protocol HTTPRequestInterceptorMixin {
	var requestInterceptors: [any HTTPRequestInterceptor] { get }
	func applyInterceptors(request: URLRequest) async throws -> URLRequest
}
extension HTTPRequestInterceptorMixin {
	public func applyInterceptors(request: URLRequest) async throws -> URLRequest {
		var request = request
		for interceptor in requestInterceptors {
			request = try await interceptor.intercept(request: request)
		}
		return request
	}
}
