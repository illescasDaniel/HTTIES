import Foundation

public protocol HTTPRequestInterceptor {
	func intercept(request: URLRequest) async throws -> URLRequest
}
