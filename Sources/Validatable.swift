import XCERequirement

//===

public
protocol Validatable
{
    var isValid: Bool { get }
    func validate() throws
}

//===

public
protocol ValidatableValue: Validatable
{
    associatedtype Value
    
    typealias Draft = Value?
    
    static
    var requirements: [Requirement<Value>] { get }
    
    var draft: Draft { get set }
    
    init()
}

// MARK: - ValidatableSpecialized - Helpers

public
extension ValidatableValue
{
    mutating
    func set(_ newValue: Draft) throws
    {
        draft = newValue
        try validate()
    }
}
    
// MARK: - ValidatableSpecialized - Initializers

public
extension ValidatableValue
{
    init(_ initialValue: Draft)
    {
        self.init()
        self.draft = initialValue
    }
}
