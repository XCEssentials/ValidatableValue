/*

 MIT License

 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

// public
extension Swift.Optional: Validatable
    where
    Wrapped: ValidatableValueWrapper
{
    // see implementations below
}

// MARK: - Validatable support

public
extension Swift.Optional
    where
    Wrapped: ValidatableValueWrapper
{
    func validate() throws
    {
        if
            case .some(let validatable) = self
        {
            try validatable.validate()
        }
    }

    func validValue() throws -> Wrapped.Value? // NON-Mandatory!
    {
        switch self
        {
            case .none:
                return nil // 'nil' is allowed

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }

    func validValue(
        _ collectError: inout [ValidationError]
        ) throws -> Wrapped.Value? // NON-Mandatory!
    {
        let result: Wrapped.Value?

        //---

        do
        {
            result = try validValue()
        }
        catch let error as ValidationError
        {
            collectError.append(error)
            result = nil
        }
        catch
        {
            // an unexpected error should be thrown to the upper level
            throw error
        }

        //---

        return result
    }
}

// MARK: - Validatable support - when wrap Mandatory & ValueWrapper

public
extension Swift.Optional
    where
    Wrapped: Mandatory & ValidatableValueWrapper
{
    func validate() throws
    {
        // throw if no value!
        // or pass validation to the non-empty value
        switch self
        {
            case .none:
                throw ValidationError.mandatoryValueIsNotSet(
                    origin: displayName,
                    report: Wrapped.defaultEmptyValueReport
                )

            case .some(let validatable):
                try validatable.validate()
        }
    }

    func validValue() throws -> Wrapped.Value // Mandatory!
    {
        switch self
        {
            case .none:
                throw ValidationError.mandatoryValueIsNotSet(
                    origin: displayName,
                    report: Wrapped.defaultEmptyValueReport
                )

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }

    func validValue(
        _ collectError: inout [ValidationError]
        ) throws -> Wrapped.Value! // Mandatory!
    {
        let result: Wrapped.Value?

        //---

        do
        {
            result = try validValue()
        }
        catch let error as ValidationError
        {
            collectError.append(error)
            result = nil
        }
        catch
        {
            // an unexpected error should be thrown to the upper level
            throw error
        }

        //---

        return result
    }
}

// MARK: - Validatable support - when wrap Mandatory & CustomValueWrapper

public
extension Swift.Optional
    where
    Wrapped: Mandatory & WithCustomValue & ValueWrapper,
    Wrapped.Specification.Value == Wrapped.Value
{
    func validate() throws
    {
        // throw if no value!
        // or pass validation to the non-empty value
        switch self
        {
            case .none:
                throw Wrapped.reportEmptyValue()

            case .some(let validatable):
                try validatable.validate()
        }
    }

    func validValue() throws -> Wrapped.Value // Mandatory!
    {
        switch self
        {
            case .none:
                throw Wrapped.reportEmptyValue()

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }

    func validValue(
        _ collectError: inout [ValidationError]
        ) throws -> Wrapped.Value! // Mandatory!
    {
        let result: Wrapped.Value?

        //---

        do
        {
            result = try validValue()
        }
        catch let error as ValidationError
        {
            collectError.append(error)
            result = nil
        }
        catch
        {
            // an unexpected error should be thrown to the upper level
            throw error
        }

        //---

        return result
    }
}

// MARK: - Convenience helpers

//extension Swift.Optional
//    where
//    Wrapped: ValidatableValueWrapper
//{
//    /**
//     Convenience initializer useful for setting a 'let' value,
//     that only should be set once during initialization. Assigns
//     provided value and validates it right away.
//     */
//    init(
//        withValidatable value: Wrapped.Value?
//        ) throws
//    {
//        self = value.map{ .some(.init($0)) } ?? .none
//
//        //---
//
//        try self.validate()
//    }
//
//    /**
//     Set new value and validate it in single operation.
//     */
//    mutating
//    func set(_ newValue: Wrapped.Value?) throws
//    {
//        value = newValue
//        try validate()
//    }
//
//    /**
//     Validate a given value without actually setting it as current value.
//     */
//    func validate(value: Wrapped.Value?) throws
//    {
//        var tmp = self
//        try tmp.set(value)
//    }
//}

// TODO: Finish this - move to 'Optional' extension!
//public
//extension OptionalValueWrapper
//    where
//    Self: WithCustomValue,
//    Self.Specification.Value == Self.Value
//{
//    /**
//     This is a special getter that allows to get an optional valid value
//     OR collect an error, if stored value is invalid.
//     This helper function allows to collect issues from multiple
//     validateable values wihtout throwing an error immediately,
//     but received value should ONLY be used/read if the 'collectError'
//     is empty in the end.
//     */
//    func validValue(
//        _ accumulateValidationError: inout [ValidationError]
//        ) throws -> Value?
//    {
//        let result: Value?
//
//        //---
//
//        do
//        {
//            result = try validValue()
//        }
//        catch let error as ValidationError
//        {
//            accumulateValidationError.append(error)
//            result = nil
//        }
//        catch
//        {
//            // anything except 'ValueValidationFailed'
//            // should be thrown to the upper level
//            throw error
//        }
//
//        //---
//
//        return result
//    }
//
//    /**
//     It returns whatever is stored in 'value', or
//     throws 'ValidationError' if 'value' is not 'nil'
//     and failed to pass validation.
//     */
//    func validValue() throws -> Value?
//    {
//        guard
//            let result = value
//        else
//        {
//            // 'nil' is allowed
//            return nil
//        }
//
//        //---
//
//        // non-'nil' value must be checked againts requirements
//
//        try checkNonEmptyValue(result)
//
//        //---
//
//        return result
//    }
//}
