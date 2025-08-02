import Foundation

public enum AppNetworkRequestError: Error, @unchecked Sendable {
	case invalidScheme(String?)
	case invalidJSONObject([String: Any])
}
