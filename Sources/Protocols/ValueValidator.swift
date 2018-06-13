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
 Represents single purpose logic related to
 validation of one particular kind of values,
 usually within one particular type/entity.
 It's not supposed to be instantiated,
 it should be more like a scope, so recommended
 to be used on 'enum' types.
 */
public
protocol ValueValidator
{
    associatedtype Input

    static
    var conditions: [Condition<Input>] { get }

    static
    func prepareValidationFailureReport(
        with displayName: String,
        failedConditions: [String]
        ) -> (title: String, message: String)
}

//---

public
extension ValueValidator
    where
    Self: ValidationFailureReportAuto
{
    static
    func prepareValidationFailureReport(
        with displayName: String,
        failedConditions: [String]
        ) -> (title: String, message: String)
    {
        return (
            "\"\(displayName)\" validation failed",
            "\"\(displayName)\" is invalid, because it does not satisfy following conditions: \(failedConditions)."
        )
    }
}
