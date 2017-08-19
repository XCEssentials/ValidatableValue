import XCERequirement

//===

public
struct ValidatableValue<Value: Validatable>
{
    public
    var rawValue: Any?
    
    public
    let requirements: [Requirement<Value>]
}

//===

extension ValidatableValue
{
    static
    func validate(
        _ rawValue: Any?,
        with requirements: [Requirement<Value>]
        ) throws -> Value
    {
        guard
            let result = rawValue.flatMap({ $0 as? Value })
        else
        {
            throw WrongBaseType()
        }
        
        //===
        
        try requirements.forEach { try $0.check(with: result) }
        
        //===
        
        return result
    }
}

//===

public
extension ValidatableValue
{
    var value: Value?
    {
        get
        {
            return rawValue.flatMap { $0 as? Value }
        }
        set
        {
            rawValue = newValue
        }
    }
    
    var validValue: Value?
    {
        get
        {
            let result = try? type(of: self).validate(
                rawValue,
                with: requirements
            )
            
            return result.flatMap { $0 }
        }
        set
        {
            rawValue = try? type(of: self).validate(
                newValue,
                with: requirements
            )
        }
    }
}

//===

public
extension ValidatableValue
{
    @discardableResult
    func validateCurrentValue() throws -> Value
    {
        return try type(of: self).validate(
            rawValue,
            with: requirements
        )
    }
    
    @discardableResult
    func validate(_ newValue: Any?) throws -> Value
    {
        return try type(of: self).validate(
            newValue,
            with: requirements
        )
    }
    
    mutating
    func set(_ newValue: Any?) throws
    {
        rawValue = try type(of: self).validate(
            newValue,
            with: requirements
        )
    }
}

//===

public
extension ValidatableValue
{
    func isValid() -> Bool
    {
        do
        {
            try validateCurrentValue()
        }
        catch
        {
            return false
        }
        
        //===
        
        return true
    }
    
    func isValid(_ newValue: Any?) -> Bool
    {
        do
        {
            try validate(newValue)
        }
        catch
        {
            return false
        }
        
        //===
        
        return true
    }
}
