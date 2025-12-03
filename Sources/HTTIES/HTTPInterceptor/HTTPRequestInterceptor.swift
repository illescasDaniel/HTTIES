import Foundation

public protocol HTTPRequestInterceptor: Sendable {
	func intercept(request: URLRequest) async throws -> URLRequest
}
