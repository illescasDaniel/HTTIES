import Foundation

struct CustomStringConvertibleMock: CustomStringConvertible {
	let value: String
	var description: String {
		return value
	}
}
