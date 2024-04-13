import Foundation

public protocol HTTPRequestInterceptorMixin {
	var requestInterceptors: [any HTTPRequestInterceptor] { get }
	func applyInterceptors(toMutableRequest mutableRequest: inout URLRequest) async throws
}
extension HTTPRequestInterceptorMixin {
	public func applyInterceptors(toMutableRequest mutableRequest: inout URLRequest) async throws {
		for interceptor in requestInterceptors {
			try await interceptor.intercept(request: &mutableRequest)
		}
	}
}
