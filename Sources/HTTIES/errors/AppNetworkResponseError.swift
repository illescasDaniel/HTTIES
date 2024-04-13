import Foundation

public enum AppNetworkResponseError: Error, Equatable {
	case unexpected(statusCode: Int)
}
