public
protocol ValidatableValueError: Error { }

//===

public
struct WrongBaseType: ValidatableValueError { }
