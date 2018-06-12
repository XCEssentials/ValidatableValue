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
protocol ValidatableValueError: Error, CustomStringConvertible
{
    var context: String { get }
}

//---

public
struct ValueNotSet: ValidatableValueError
{
    public
    let context: String
}

//---

public
struct ConditionUnsatisfied: ValidatableValueError
{
    public
    let context: String

    public
    let input: Any

    public
    let condition: String
}

//---

public
struct ValueValidationFailed: ValidatableValueError
{
    public
    let context: String

    public
    let input: Any

    public
    let failedConditions: [String]
}

//---

public
struct EntityValidationFailed: ValidatableValueError
{
    public
    let context: String

    public
    let issues: [ValueValidationFailed]
}

// MARK: - CustomStringConvertible conformance

public
extension ValidatableValueError
{
    var description: String
    {
        if
            self is ValueNotSet
        {
            return "Value is not set."
        }
        else
        if
            let error = self as? ConditionUnsatisfied
        {
            return """
                ======
                Context: \(error.context).
                Input: \(error.input).
                Failed condition: \(error.condition).
                ---/
                """
        }
        else
        if
            let error = self as? ValueValidationFailed
        {
            return """
                ======
                Context: \(error.context).
                Input: \(error.input).
                Failed conditions: \(error.failedConditions).
                ---/
                """
        }
        else
        if
            let error = self as? EntityValidationFailed
        {
            let issues = error
                .issues
                .map{

                    """
                    Input: \($0.input). Failed conditions: \($0.failedConditions).
                    """
                }
                .joined(
                    separator: """
                        ---
                        """
                )

            //---

            return """
                ======
                Context: \(error.context).
                Issues:
                \(issues)
                ---/
                """
        }
        else
        {
            return "\(self)"
        }
    }
}
