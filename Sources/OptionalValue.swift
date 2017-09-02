public
struct OptionalValue<T>: OptionalValidatable
{
    public
    typealias Value = T
    
    public
    static
    var validations: [Validation<Value>]
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
            
            try type(of: self).validations.forEach {
                
                try $0.perform(with: result)
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
    @discardableResult
    func mapValid<U>(_ transform: (Value) throws -> U) rethrows -> U?
    {
        return try (try? valueIfValid())?.flatMap({ $0 }).map(transform)
    }
    
    @discardableResult
    func flatMapValid<U>(_ transform: (Value) throws -> U?) rethrows -> U?
    {
        return try (try? valueIfValid()).flatMap({ $0 }).flatMap(transform)
    }
}
