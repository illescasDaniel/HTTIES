import Foundation

public protocol HTTPInoutRequestInterceptor: HTTPRequestInterceptor {
	func intercept(request: inout URLRequest) async throws
}
public extension HTTPInoutRequestInterceptor {
	func intercept(request: URLRequest) async throws -> URLRequest {
		var mutableRequest = request
		try await self.intercept(request: &mutableRequest)
		return mutableRequest
	}
}
