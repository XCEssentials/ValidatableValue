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
protocol MandatoryValueWrapper: ValidatableValueWrapper {}

//---

private
extension MandatoryValueWrapper
{
    /**
     It returns non-empty (safely unwrapped) 'value',
     or throws 'ValueNotSet' error, if the 'value' is 'nil.
     */
    func unwrapValueOrThrow() throws -> Value
    {
        let currentContext = Utils.globalContext(with: self)

        //---

        guard
            let result = value
        else
        {
            // 'value' is 'nil', which is NOT allowed
            throw ValueNotSet(context: currentContext)
        }

        //---

        return result
    }
}

//---

public
extension MandatoryValueWrapper
{
    /**
     It returns non-empty (safely unwrapped) 'value',
     or throws 'ValueNotSet' error, if the 'value' is 'nil.
     */
    func validValue() throws -> Value
    {
        return try unwrapValueOrThrow()
    }
}

//---

public
extension MandatoryValueWrapper
    where
    Self: CustomValidatable,
    Self.Validator: ValueValidator,
    Self.Validator.Input == Self.Value
{
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

        let currentContext = Utils.globalContext(with: self)
        var failedConditions: [String] = []

        Validator.conditions.forEach
        {
            do
            {
                try $0.validate(context: currentContext, value: result)
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
            throw ValidationFailed(
                context: currentContext,
                input: result,
                failedConditions: failedConditions
            )
        }

        //---

        return result
    }
}
