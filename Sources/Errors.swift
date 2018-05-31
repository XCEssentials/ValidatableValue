public
protocol ValidatableValueError: Error { }

//---

public
struct ValueNotSet: ValidatableValueError { }

//---

public
struct ValidationFailed: ValidatableValueError, CustomStringConvertible
{
    public
    let description: String
    
    init(_ validation: String, input: Any)
    {
        self.description = "Validation [\(validation)] failed with input: \(input)."
    }
}
