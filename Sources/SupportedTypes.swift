// Inspiration: https://stackoverflow.com/a/34300964/2312115

public
protocol Validatable { }

// list of types: https://www.tutorialspoint.com/swift/swift_data_types.htm

extension Int: Validatable { }
extension UInt: Validatable { }
extension Float: Validatable { }
extension Double: Validatable { }
extension Bool: Validatable { }
extension String: Validatable { }
extension Character: Validatable { }

extension Int8: Validatable { }
extension UInt8: Validatable { }
extension Int32: Validatable { }
extension UInt32: Validatable { }
extension Int64: Validatable { }
extension UInt64: Validatable { }
