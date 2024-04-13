import Foundation

public protocol HTTPResponseInterceptor {
	func intercept(data: inout Data, response: inout HTTPURLResponse, error: inout Error?, for request: URLRequest)
}
