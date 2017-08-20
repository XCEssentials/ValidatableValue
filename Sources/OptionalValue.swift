import XCERequirement

//===

public
struct OptionalValue<T>: ValidatableSpecialized
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
        self.draft = initialValue
        self.requirements = requirements
    }
}

// MARK: - Custom properties

public
extension OptionalValue
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
}

// MARK: - Validatable support

public
extension OptionalValue
{
    public
    var isValid: Bool
    {
        do
        {
            try validate()
            
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
        if
            let candidate = draft
        {
            // non-'nil' draft value must be checked againts requirements
            
            try requirements.forEach { try $0.check(with: candidate) }
        }
        else
        {
            // 'draft' is 'nil', which is a valid 'value'
        }
    }
}
