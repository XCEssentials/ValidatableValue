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
struct ConditionUnsatisfied: Error
{
    public
    let input: Any

    public
    let condition: String
}

//---

public
protocol ValidatableValueError: Error
{
    var origin: ValueInstanceReference { get }
}

//---

public
struct ValueIsNotSet: ValidatableValueError
{
    public
    let origin: ValueInstanceReference
}

//---

public
struct ValueIsNotValid: ValidatableValueError
{
    public
    let origin: ValueInstanceReference

    public
    let input: Any

    public
    let failedConditions: [String]
}

//---

public
struct EntityValidationFailed: Error
{
    public
    let issues: [ValidatableValueError]

    //---

    // internal
    init(
        issues: [ValidatableValueError]
        )
    {
        self.issues = issues
    }
}

public
extension Array where Element == ValidatableValueError
{
    func asValidationIssues(
        ) -> EntityValidationFailed
    {
        return EntityValidationFailed(
            issues: self
        )
    }
}
