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
    var validations: [Validation<Value>] { get }
    
    var draft: Draft { get set }
    
    init()
}

// MARK: - ValidatableValue - Helpers

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
    
// MARK: - ValidatableValue - Initializers

public
extension ValidatableValue
{
    init(_ initialValue: Draft)
    {
        self.init()
        self.draft = initialValue
    }
}

// MARK: - ValidatableValue - Higher order functions

public
extension ValidatableValue
{
    @discardableResult
    func map<U>(_ transform: (Value) throws -> U) rethrows -> U?
    {
        return try draft.map(transform)
    }
    
    @discardableResult
    func flatMap<U>(_ transform: (Value) throws -> U?) rethrows -> U?
    {
        return try draft.flatMap(transform)
    }
}
