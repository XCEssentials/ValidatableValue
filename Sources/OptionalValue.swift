import XCERequirement

//===

public
struct OptionalValue<T>: OptionalValidatable
{
    public
    typealias Value = T
    
    public
    static
    var requirements: [Requirement<Value>]
    {
        return []
    }
    
    public
    var draft: Draft
    
    public
    init() { }
}

//===

public
protocol OptionalValidatable: ValidatableValue { }

// MARK: - Custom properties

public
extension OptionalValidatable
{
    public
    var value: Value?
    {
        do
        {
            try validate()
            
            return draft
        }
        catch
        {
            return nil
        }
    }
    
    public
    func valueIfValid() throws -> Value?
    {
        if
            let result = draft
        {
            // non-'nil' draft value must be checked againts requirements
            
            try type(of: self).requirements.forEach {
                
                try $0.check(with: result)
            }
            
            //===
            
            return result
        }
        else
        {
            // 'draft' is 'nil', which is a valid 'value'
            
            return nil
        }
    }
}

// MARK: - Validatable support

public
extension OptionalValidatable
{
    public
    var isValid: Bool
    {
        do
        {
            _ = try valueIfValid()
            
            return true
        }
        catch
        {
            return false
        }
    }
    
    public
    func validate() throws
    {
        _ = try valueIfValid()
    }
}

// MARK: - Extra helpers

public
extension OptionalValidatable
{
    /**
     
     Executes 'transform' with 'value' if it's valid
     
     */
    @discardableResult
    func map<U>(_ transform: (Value?) throws -> U) rethrows -> U?
    {
        if
            isValid
        {
            return try transform(draft)
        }
        else
        {
            return nil
        }
    }
    
    /**
     
     Executes 'transform' with 'value' if it's non-'nil' & valid
     
     */
    @discardableResult
    func flatMap<U>(_ transform: (Value) throws -> U) rethrows -> U?
    {
        if
            isValid,
            let result = draft
        {
            return try transform(result)
        }
        else
        {
            return nil
        }
    }
}
