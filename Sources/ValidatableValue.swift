import XCERequirement

//===

public
struct Wrapped<Value>
{
    public
    let value: Value
    
    init(_ value: Value)
    {
        self.value = value
    }
}

//===

public
struct ValidatableValue<Value>
{
    var wrapped: Wrapped<Value>?
    
    public
    let requirements: [Requirement<Value>]
}

//===

extension ValidatableValue
{
    static
    func validate<T>(
        _ candidate: T,
        with requirements: [Requirement<Value>]
        ) throws -> Value
    {
        guard
            let result = candidate as? Value
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
            return wrapped?.value
        }
        set
        {
            guard
                let newValue = newValue
            else
            {
                return wrapped = nil
            }
            
            //===
            
            wrapped = Wrapped(newValue)
        }
    }
    
    var validValue: Value?
    {
        get
        {
            guard
                let wrapped = wrapped,
                let result = try? type(of: self).validate(
                    wrapped.value,
                    with: requirements
                )
            else
            {
                return nil
            }
            
            //===
            
            return result
        }
        set
        {
            guard
                let candidate = newValue,
                let result = try? type(of: self).validate(
                    candidate,
                    with: requirements
                )
            else
            {
                return wrapped = nil
            }
            
            //===
            
            wrapped = Wrapped(result)
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
        guard
            let wrapped = wrapped
        else
        {
            throw EmptyValue()
        }
        
        //===
        
        return try type(of: self).validate(
            wrapped.value,
            with: requirements
        )
    }
    
    @discardableResult
    func validate(_ newValue: Value) throws -> Value
    {
        return try type(of: self).validate(
            newValue,
            with: requirements
        )
    }
    
    mutating
    func set(_ newValue: Value) throws
    {
        let result = try type(of: self).validate(
            newValue,
            with: requirements
        )
        
        //===
        
        wrapped = Wrapped(result)
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
    
    func wouldBeValid(_ newValue: Value) -> Bool
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
