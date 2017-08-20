import XCERequirement

//===

public
struct MandatoryValue<T>: ValidatableSpecialized
{
    public
    typealias Value = T
    
    // MARK: - ValidatableSpecialized - Properties

    public
    var draft: Draft
    
    public
    let requirements: [Requirement<Value>]
    
    // MARK: - ValidatableSpecialized - Initializers

    public
    init(_ initialValue: Draft,
         requirements: [Requirement<Value>])
    {
        self.requirements = requirements
        self.draft = initialValue
    }
}

// MARK: - Custom members

public
extension MandatoryValue
{
    public
    var value: Value!
    {
        return try? valueIfValid()
    }
    
    public
    struct ValueNotSet: ValidatableValueError { }
    
    public
    func valueIfValid() throws -> Value
    {
        if
            let result = draft
        {
            // non-'nil' draft value must be checked againts requirements
            
            try requirements.forEach { try $0.check(with: result) }
            
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
extension MandatoryValue
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
