import Foundation

public protocol HTTPInterceptor {
	func data(for httpRequest: HTTPURLRequest, httpHandler: HTTPRequestChain) async throws -> (Data, HTTPURLResponse)
}
