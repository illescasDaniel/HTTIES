import Foundation

public struct QueryParamValue: ExpressibleByNilLiteral, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral, ExpressibleByArrayLiteral {
	public typealias ArrayLiteralElement = CustomStringConvertible

	let stringValue: String?

	public init(stringValue: String?) {
		self.stringValue = stringValue
	}

	public init(nilLiteral: ()) {
		self.stringValue = nil
	}

	public init(stringLiteral value: StringLiteralType) {
		self.stringValue = value
	}

	public init(integerLiteral value: IntegerLiteralType) {
		self.stringValue = String(value)
	}

	public init(booleanLiteral value: BooleanLiteralType) {
		self.stringValue = value ? "1" : "0" // initialize this struct to nil to simple not pass any value to the parameter
	}

	public init(arrayLiteral elements: ArrayLiteralElement...) {
		self.stringValue = elements.map { String(describing: $0) }.joined(separator: ",")
	}

	private init<T>(_ value: T) {
		switch value {
		case let integer as IntegerLiteralType:
			self.init(integerLiteral: integer)
		case let string as StringLiteralType:
			self.init(stringLiteral: string)
		case let boolean as BooleanLiteralType:
			self.init(booleanLiteral: boolean)
		case let array as [ArrayLiteralElement]:
			self.init(arrayLiteral: array)
		case let stringConvertible as CustomStringConvertible:
			self.init(stringValue: String(describing: stringConvertible))
		default:
			self.init(stringValue: nil)
		}
	}

	/// Given a generic value, it tries to initialize a `QueryParamValue` type by interpreting its value.
	///
	/// - if `value` is boolean: it will be convertedto 1 or 0 internally
	/// - if `value` is an array of `CustomStringConvertible` things: the values will be separated by a comma: [1, 2] -> "1,2"
	/// - if `value` is an any other `CustomStringConvertible` thing: the values will be obtained form calling "String(describing:)". Be careful here, do not pass weird stuff.
	/// - else, no value will be used
	///
	public static func value<T>(_ value: T) -> Self {
		return .init(value)
	}

	public static func value<R: RawRepresentable>(_ value: R) -> Self where R.RawValue: CustomStringConvertible {
		return .init(String(describing: value.rawValue))
	}
}
