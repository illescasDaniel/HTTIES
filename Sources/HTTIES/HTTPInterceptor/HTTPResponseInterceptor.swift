import Foundation

public protocol HTTPResponseInterceptor {
	func intercept(data: Data, response: HTTPURLResponse, error: Error?, for request: URLRequest) async throws -> (Data, HTTPURLResponse, Error?)
}
