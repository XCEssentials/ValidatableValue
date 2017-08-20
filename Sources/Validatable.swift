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
protocol ValidatableSpecialized: Validatable
{
    associatedtype Value
    
    typealias Draft = Value?
    
    var draft: Draft { get set }
    var requirements: [Requirement<Value>] { get }
    
    init(_ initialValue: Draft,
         requirements: [Requirement<Value>])
}

// MARK: - ValidatableSpecialized - Helpers

public
extension ValidatableSpecialized
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
extension ValidatableSpecialized
{
    init()
    {
        self.init(nil, requirements: [])
    }
}

public
extension ValidatableSpecialized
{
    init(_ requirementsGetter: () -> [Requirement<Value>])
    {
        self.init(nil, requirements: requirementsGetter())
    }
    
    init(_ requirements: Requirement<Value>...)
    {
        self.init(nil, requirements: requirements)
    }
}

public
extension ValidatableSpecialized
{
    init(
        _ initialValue: Draft,
        requirements getter: () -> [Requirement<Value>])
    {
        self.init(initialValue, requirements: getter())
    }
    
    init(
        _ initialValue: Draft,
        requirements: Requirement<Value>...)
    {
        self.init(initialValue, requirements: requirements)
    }
}
