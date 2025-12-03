import Foundation

public enum AppNetworkRequestError: Error, @unchecked Sendable {
	case invalidScheme(String?)
	case invalidObject(Any)
}
