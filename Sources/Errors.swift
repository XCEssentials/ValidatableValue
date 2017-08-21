public
protocol ValidatableValueError: Error { }

//===

public
struct ValueNotSet: ValidatableValueError { }
