public
struct MandatoryValue<T>: MandatoryValidatable
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

public
protocol MandatoryValidatable: ValidatableValue { }

// MARK: - Custom members

public
extension MandatoryValidatable
{
    public
    var value: Value!
    {
        return try? valueIfValid()
    }
    
    public
    func valueIfValid() throws -> Value
    {
        if
            let result = draft
        {
            // non-'nil' draft value must be checked againts requirements
            
            try type(of: self).validations.forEach
            {
                try $0.perform(with: result)
            }
            
            //===
            
            return result
        }
        else
        {
            // 'draft' is 'nil', which is NOT allowed
            
            throw ValueNotSet()
        }
    }
}

// MARK: - Validatable support

public
extension MandatoryValidatable
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
extension MandatoryValidatable
{
    @discardableResult
    func mapValid<U>(_ transform: (Value) throws -> U) rethrows -> U?
    {
        return try (try? valueIfValid()).map(transform)
    }
    
    @discardableResult
    func flatMapValid<U>(_ transform: (Value) throws -> U?) rethrows -> U?
    {
        return try (try? valueIfValid()).flatMap(transform)
    }
}
