import Foundation

protocol HTTPInoutResponseInterceptor: HTTPResponseInterceptor {
	func intercept(data: inout Data, response: inout HTTPURLResponse, error: inout Error?, for request: URLRequest) async throws
}
extension HTTPInoutResponseInterceptor {
	func intercept(data: Data, response: HTTPURLResponse, error: Error?, for request: URLRequest) async throws -> (Data, HTTPURLResponse, Error?) {
		var (data, response, error) = (data, response, error)
		try await self.intercept(data: &data, response: &response, error: &error, for: request)
		return (data, response, error)
	}
}
