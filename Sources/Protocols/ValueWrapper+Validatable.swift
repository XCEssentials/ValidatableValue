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

public
extension ValueWrapper
    where Self: Validatable
{
    /**
     Convenience initializer useful for setting a 'let' value,
     that only should be set once during initialization. Assigns
     provided value and validates it right away.
     */
    init(
        const value: Value
        ) throws
    {
        self.init()
        try self.set(value)
    }

    /**
     Set new value and validate it in single operation.
     */
    mutating
    func set(_ newValue: Value?) throws
    {
        value = newValue
        try validate()
    }

    /**
     Validate a given value without actually setting it to current value.
     */
    func validate(value: Value?) throws
    {
        var tmp = self
        try tmp.set(value)
    }
}

//---

public
extension ValueWrapper
    where Self: Validatable & CustomNamed & CustomReportableAuto
{
    func prepareReport(
        with error: ValidatableValueError
        ) -> (title: String, message: String)
    {
        if
            error is ValueIsNotSet
        {
            return (
                "\"\(self.name)\" is empty",
                "\"\(self.name)\" is empty, but expected to be a non-empty value."
            )
        }
        if
            let error = error as? ValueIsNotValid
        {
            return (
                "\"\(self.name)\" validation failed",
                "\"\(self.name)\" is invalid, because it does not satisfy following conditions: \(error.failedConditions)."
            )
        }
        else
        {
            return (
                "Something is wrong with \"\(self.name)\"",
                "An unexpected error occured during \"\(self.name)\" validation."
            )
        }
    }
}

//---

public
extension ValueWrapper
    where Self: Validatable & CustomReportableAuto
{
    func prepareReport(
        with error: ValidatableValueError
        ) -> (title: String, message: String)
    {
        if
            error is ValueIsNotSet
        {
            return (
                "Value is empty",
                "Value is empty, but expected to be a non-empty value."
            )
        }
        if
            let error = error as? ValueIsNotValid
        {
            return (
                "Value validation failed",
                "Value is invalid, because it does not satisfy following conditions: \(error.failedConditions)."
            )
        }
        else
        {
            return (
                "Something is wrong",
                "An unexpected error occured during value validation."
            )
        }
    }
}
