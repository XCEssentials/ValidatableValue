public
protocol ValidatableValueError: Error { }

//===

public
struct EmptyValue: ValidatableValueError { }

public
struct WrongBaseType: ValidatableValueError { }
