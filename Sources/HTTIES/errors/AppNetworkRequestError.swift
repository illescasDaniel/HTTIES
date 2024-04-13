import Foundation

public enum AppNetworkRequestError: Error {
	case invalidScheme(String?)
	case invalidJSONObject([String: Any])
}
