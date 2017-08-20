import XCERequirement

//===

public
extension ValidatableValue
{
    init(
        _ initialValue: Value,
        _ requirementsGetter: () -> [Requirement<Value>] = { return [] })
    {
        self.wrapped = Wrapped(initialValue)
        self.requirements = requirementsGetter()
    }
    
    init(
        _ requirementsGetter: () -> [Requirement<Value>] = { return [] })
    {
        self.wrapped = nil
        self.requirements = requirementsGetter()
    }
}

public
extension ValidatableValue where Value: ExpressibleByNilLiteral
{
    init(
        _ requirementsGetter: () -> [Requirement<Value>] = { return [] })
    {
        self.wrapped = Wrapped(nil)
        self.requirements = requirementsGetter()
    }
}

//===

public
extension ValidatableValue
{
    init(
        _ initialValue: Value,
        _ requirements: Requirement<Value>...)
    {
        self.init(initialValue, { return requirements })
    }
    
    init(_ requirements: Requirement<Value>...)
    {
        self.init({ return requirements })
    }
}
