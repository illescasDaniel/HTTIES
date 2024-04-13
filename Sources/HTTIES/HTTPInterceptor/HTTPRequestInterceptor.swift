import Foundation

public protocol HTTPRequestInterceptor {
	func intercept(request: inout URLRequest) async throws
}
