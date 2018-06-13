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

/**
 Emphasizes the fact that the value stored inside
 can only be considered as 'valid' if it's non-empty,
 so it's 'validValue()' function returns non-empty value.
 */
public
protocol MandatoryValueWrapper: ValueWrapper, Validatable
{
    func prepareEmptyValueReport(
        ) -> (title: String, message: String)

    func prepareValidationFailureReport(
        with failedConditions: [String]
        ) -> (title: String, message: String)
}

//---

// MARK: - Reporting

public
extension MandatoryValueWrapper
{
    func prepareEmptyValueReport(
        ) -> (title: String, message: String)
    {
        return (
            "\"\(self.displayName)\" is empty",
            "\"\(self.displayName)\" is empty, but expected to be non-empty."
        )
    }

    func prepareValidationFailureReport(
        with failedConditions: [String]
        ) -> (title: String, message: String)
    {
        return (
            "\"\(self.displayName)\" validation failed",
            "\"\(self.displayName)\" is invalid, because it does not satisfy following conditions: \(failedConditions)."
        )
    }
}

// MARK: - unwrapValueOrThrow()

private
extension MandatoryValueWrapper
{
    /**
     It returns non-empty (safely unwrapped) 'value',
     or throws 'ValueNotSet' error, if the 'value' is 'nil.
     */
    func unwrapValueOrThrow() throws -> Value
    {
        guard
            let result = value
        else
        {
            // 'value' is 'nil', which is NOT allowed
            throw ValidationError.mandatoryValueIsNotSet(
                origin: displayName,
                report: prepareEmptyValueReport()
            )
        }

        //---

        return result
    }
}

// MARK: - Validation

public
extension MandatoryValueWrapper
{
    func validate() throws
    {
        _ = try validValue()
    }

    /**
     USE THIS CAREFULLY!
     This is a special getter that allows to get non-optional valid value
     OR collect an error, if stored value is  invalid,
     while still returning a non-optional value. Notice, that result is
     implicitly unwrapped, but may be actually 'nil'. If stored 'value'
     is invalid - the function adds validation error into the
     'collectError' array and returns implicitly unwrapped 'nil'.
     This helper function allows to collect issues from multiple
     validateable values wihtout throwing an error immediately,
     but received value should ONLY be used/read if the 'collectError'
     is empty in the end.
     */
    func validValue(
        _ accumulateValidationError: inout [ValidationError]
        ) throws -> Value!
    {
        let result: Value?

        //---

        do
        {
            result = try validValue()
        }
        catch let error as ValidationError
        {
            accumulateValidationError.append(error)
            result = nil
        }
        catch
        {
            // anything except 'ValueValidationFailed'
            // should be thrown to the upper level
            throw error
        }

        //---

        return result!
    }

    /**
     It returns non-empty (safely unwrapped) 'value',
     or throws 'ValueNotSet' error, if the 'value' is 'nil.
     */
    func validValue() throws -> Value
    {
        return try unwrapValueOrThrow()
    }
}

// MARK: - Validation + CustomValidatable

public
extension MandatoryValueWrapper
    where
    Self: CustomValidatable,
    Self.Validator: ValueValidator,
    Self.Validator.Input == Self.Value
{
    func validate() throws
    {
        _ = try validValue()
    }

    /**
     USE THIS CAREFULLY!
     This is a special getter that allows to get non-optional valid value
     OR collect an error, if stored value is  invalid,
     while still returning a non-optional value. Notice, that result is
     implicitly unwrapped, but may be actually 'nil'. If stored 'value'
     is invalid - the function adds validation error into the
     'collectError' array and returns implicitly unwrapped 'nil'.
     This helper function allows to collect issues from multiple
     validateable values wihtout throwing an error immediately,
     but received value should ONLY be used/read if the 'collectError'
     is empty in the end.
     */
    func validValue(
        _ accumulateValidationError: inout [ValidationError]
        ) throws -> Value!
    {
        let result: Value?

        //---

        do
        {
            result = try validValue()
        }
        catch let error as ValidationError
        {
            accumulateValidationError.append(error)
            result = nil
        }
        catch
        {
            // anything except 'ValueValidationFailed'
            // should be thrown to the upper level
            throw error
        }

        //---

        return result!
    }

    /**
     It returns non-empty (safely unwrapped) 'value',
     or throws 'ValueNotSet' error if the 'value' is 'nil',
     or throws 'ValidationFailed' error if at least one
     of the custom conditions from Validator has failed.
     */
    func validValue() throws -> Value
    {
        let result = try unwrapValueOrThrow()

        //---

        // non-'nil' value must be checked againts requirements

        var failedConditions: [String] = []

        Validator.conditions.forEach
        {
            do
            {
                try $0.validate(value: result)
            }
            catch
            {
                if
                    let error = error as? ConditionUnsatisfied
                {
                    failedConditions.append(error.condition)
                }
            }
        }

        //---

        guard
            failedConditions.isEmpty
        else
        {
            throw ValidationError.valueIsNotValid(
                origin: displayName,
                value: result,
                failedConditions: failedConditions,
                report: prepareValidationFailureReport(with: failedConditions)
            )
        }

        //---

        return result
    }
}
