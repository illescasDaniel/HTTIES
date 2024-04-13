import Foundation
@testable import HTTIES

final class MockInterceptor: HTTPInterceptor {
	var interceptedRequestURL: URL?

	func data(for httpRequest: HTTPURLRequest, httpRequestChain: HTTPRequestChain) async throws -> (Data, HTTPURLResponse) {
		interceptedRequestURL = httpRequest.urlRequest.url
		let (data, response) = try await httpRequestChain.proceed(httpRequest)
		return (data, response)
	}
}
