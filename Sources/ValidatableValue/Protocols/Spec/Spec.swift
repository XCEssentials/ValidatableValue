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
 Describes custom value type for a wrapper.
 */
public
protocol ValueSpecification: DisplayNamed
{
    associatedtype Value: Codable & Equatable

    /**
     Set of conditions for the 'Value' which gonna be used
     for value validation.
     */
    static
    var conditions: [Condition<Value>] { get }

    /**
     In case the 'Value' itself conforms to 'Validatable' protocol,
     should we validate it during validation process, in addition to
     check againts this specification conditions (if presented)?
     */
    static
    var performBuiltInValidation: Bool { get }


}

//---

// internal
extension ValueSpecification
{
    static
    func collectFailedConditions(
        _ valueToCheck: Self.Value
        ) throws -> [String]
    {
        var result: [String] = []

        //---

        try conditions.forEach
        {
            do
            {
                try $0.validate(value: valueToCheck)
            }
            catch let error as ConditionUnsatisfied
            {
                result.append(error.condition)
            }
            catch
            {
                // an unexpected error, just throw it right away
                throw error
            }
        }

        //---

        return result
    }

    static
    func prepareReport(
        value: Any?,
        failedConditions: [String],
        builtInValidationIssues: [ValidationError],
        suggestedReport: Report
        ) -> Report
    {
        var result = suggestedReport

        //---

        if
            let cutomReporting = self as? CustomValueReport.Type
        {
            let context = ValueReportContext(
                origin: displayName,
                value: value,
                failedConditions: failedConditions,
                builtInValidationIssues: builtInValidationIssues
            )

            cutomReporting.reviewReport(context, &result)
        }

        //---

        return result
    }

    static
    func defaultValidationReport(
        with failedConditions: [String]
        ) -> Report
    {
        return (
            "\"\(displayName)\" validation failed",
            "\"\(displayName)\" is invalid, because it does not satisfy following conditions: \(failedConditions)."
        )
    }
}
