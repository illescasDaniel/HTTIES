import Foundation
@testable import HTTIES

final class MockInterceptor: HTTPInterceptor {
	var interceptedRequestURL: URL?

	func data(for httpRequest: HTTPURLRequest, httpHandler: HTTPRequestChain) async throws -> (Data, HTTPURLResponse) {
		interceptedRequestURL = httpRequest.urlRequest.url
		let (data, response) = try await httpHandler.proceed(httpRequest)
		return (data, response)
	}
}
