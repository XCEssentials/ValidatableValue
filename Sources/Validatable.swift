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

public
func << <VV, T>(lhs: inout VV, rhs: T?) throws where
    VV: ValidatableValue,
    VV.Value == T
{
    try lhs.set(rhs)
}

infix operator <?

public
func <? <VV, T>(lhs: inout VV, rhs: T?) where
    VV: ValidatableValue,
    VV.Value == T
{
    lhs.draft = rhs
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
