import Foundation

public protocol HTTPResponseInterceptorMixin {
	var responseInterceptors: [any HTTPResponseInterceptor] { get }
	func applyInterceptors(toData data: inout Data, response: inout HTTPURLResponse, error: inout Error?, for urlRequest: URLRequest)
}
extension HTTPResponseInterceptorMixin {
	public func applyInterceptors(toData data: inout Data, response: inout HTTPURLResponse, error: inout Error?, for urlRequest: URLRequest) {
		for interceptor in responseInterceptors {
			interceptor.intercept(
				data: &data,
				response: &response,
				error: &error,
				for: urlRequest
			)
		}
	}
}
