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

// MARK: - FailureReportableAuto + Mandatory

// internal
extension ValueWrapper
    where
    Self: FailureReportableAuto,
    Self: Mandatory
{
    func prepareEmptyValueReport(
        ) -> (title: String, message: String)
    {
        return (
            "Value is empty",
            "Value is empty, but expected to be a non-empty value."
        )
    }
}

// MARK: - FailureReportableAuto + Mandatory + DisplayNamed

// internal
extension ValueWrapper
    where
    Self: FailureReportableAuto,
    Self: Mandatory,
    Self: DisplayNamed
{
    func prepareEmptyValueReport(
        ) -> (title: String, message: String)
    {
        return (
            "\"\(self.displayName)\" is empty",
            "\"\(self.displayName)\" is empty, but expected to be a non-empty value."
        )
    }
}

// MARK: - FailureReportableAuto + Validatable

// internal
extension ValueWrapper
    where
    Self: FailureReportableAuto,
    Self: Validatable
{
    func prepareInvalidValueReport(
        with failedConditions: [String]
        ) -> (title: String, message: String)
    {
        return (
            "Value validation failed",
            "Value is invalid, because it does not satisfy following conditions: \(failedConditions)."
        )
    }
}

// MARK: - FailureReportableAuto + Validatable + DisplayNamed

// internal
extension ValueWrapper
    where
    Self: FailureReportableAuto,
    Self: Validatable,
    Self: DisplayNamed
{
    func prepareInvalidValueReport(
        with failedConditions: [String]
        ) -> (title: String, message: String)
    {
        return (
            "\"\(self.displayName)\" validation failed",
            "\"\(self.displayName)\" is invalid, because it does not satisfy following conditions: \(failedConditions)."
        )
    }
}
