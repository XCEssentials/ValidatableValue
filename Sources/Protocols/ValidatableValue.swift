public
protocol ValidatableValue: Validatable
{
    associatedtype RawValue
    associatedtype ValidValue

    init(conditions: [Condition<RawValue>])

    /**
     These conditions represent all requirements that expected to be
     satisfied in order for a draft value to be considered as valid.
     */
    var conditions: [Condition<RawValue>] { get }

    /**
     This property can be freely modified at any point of time.
     This is the value that is pretending to end up as final value
     if it satisfies all conditions.
     */
    var draft: RawValue? { get set }

    /**
     Supposed to evaluate 'draft' against all conditions and
     return a valid value or throw an error if any of the conditions
     is not satisfied.
     */
    func valueIfValid() throws -> ValidValue
}

// MARK: - Automatic 'Validatable' conformance

public
extension ValidatableValue
{
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

    func validate() throws
    {
        _ = try valueIfValid()
    }
}

// MARK: - Convenience helpers

public
extension ValidatableValue
{
    init(
        initialValue: RawValue? = nil,
        _ conditions: Condition<RawValue>...
        )
    {
        self.init(conditions: conditions)
        self.draft = initialValue
    }

    func check(
        _ description: String,
        _ body: @escaping Check<RawValue>.Body
        ) -> Self
    {
        var result = Self
            .init(conditions: self.conditions + [Check<RawValue>(description, body)])

        result.draft = self.draft

        return result
    }

    mutating
    func set(_ newValue: RawValue?) throws
    {
        draft = newValue
        try validate()
    }

    func validate(value: RawValue?) throws
    {
        var tmp = self
        try tmp.set(value)
    }
}
