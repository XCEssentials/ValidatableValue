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
 Special trait for 'ValueWrapper' protocol that indicates that
 empty value should be considered as invalid.
 */
public
protocol Mandatory: DisplayNamed, Trait {}

//---

//internal
extension Mandatory
{
    static
    var defaultEmptyValueReport: Report
    {
        return (
            "\"\(displayName)\" is empty",
            "\"\(displayName)\" is empty, but expected to be non-empty."
        )
    }
}

extension Mandatory
{
//    static
//    func emptyValueError<T: BasicValueWrapper>(
//        for _: T.Type
//        ) -> ValidationError
//    {
//        return ValidationError.mandatoryValueIsNotSet(
//            origin: T.displayName,
//            report: defaultEmptyValueReport(for: T.self)
//        )
//    }
//
//    static
//    func emptyValueErrorWithSpec<T: ValueWrapper>(
//        for _: T.Type
//        ) -> ValidationError
//    {
//        return ValidationError.mandatoryValueIsNotSet(
//            origin: T.displayName,
//            report: T.Specification.prepareReport(
//                value: nil,
//                failedConditions: [],
//                builtInValidationIssues: [],
//                suggestedReport: defaultEmptyValueReport(for: T.self)
//            )
//        )
//    }
}

