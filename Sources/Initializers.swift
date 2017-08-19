import XCERequirement

//===

public
extension ValidatableValue
{
    init(
        _ initialValue: Value?,
        _ requirements: [Requirement<Value>])
    {
        self.value = initialValue
        self.requirements = requirements
    }
}

//===

public
extension ValidatableValue
{
    init()
    {
        // no requirements except base value type
        
        self.init(nil, [])
    }
    
    init(_ initialValue: Value)
    {
        self.init(initialValue, [])
    }
    
    init(_ requirementsGetter: () -> [Requirement<Value>])
    {
        self.init(nil, requirementsGetter())
    }
    
    init(_ requirements: Requirement<Value>...)
    {
        self.init(nil, requirements)
    }
    
    init(_ requirements: [Requirement<Value>])
    {
        self.init(nil, requirements)
    }
    
    init(
        _ initialValue: Value?,
        _ requirements: Requirement<Value>...)
    {
        self.init(initialValue, requirements)
    }
    
    init(
        _ initialValue: Value?,
        _ requirementsGetter: () -> [Requirement<Value>])
    {
        self.init(initialValue, requirementsGetter())
    }
}
