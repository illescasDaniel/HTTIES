import Foundation

public protocol HTTPInterceptor {
	func data(for httpRequest: HTTPURLRequest, httpRequestChain: HTTPRequestChain) async throws -> (Data, HTTPURLResponse)
}
