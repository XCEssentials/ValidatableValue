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
protocol CustomValueWrapper: ValueWrapper & Validatable
    where
    Self.Value == Self.Specification.Value
{
    associatedtype Specification: ValueSpecification

}

// MARK: - Automatic Validatable support

public
extension CustomValueWrapper
{
    func validate() throws
    {
        try type(of: self).check(self.value)
    }
}

// MARK: - Helpers

public
extension CustomValueWrapper
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
        self.init(value)
        try self.validate()
    }

    /**
     Set new value and validate it in single operation.
     */
    mutating
    func set(_ newValue: Value) throws
    {
        value = newValue
        try validate()
    }

    /**
     Validate a given value without actually setting it to current value.
     */
    func validate(value: Value) throws
    {
        var tmp = self
        try tmp.set(value)
    }
}

// MARK: - Reporting

private
extension CustomValueWrapper
{
    static
    func check(_ valueToCheck: Value) throws
    {
        var failedConditions: [String] = []

        try Specification.conditions.forEach
        {
            do
            {
                try $0.validate(value: valueToCheck)
            }
            catch let error as ConditionUnsatisfied
            {
                failedConditions.append(error.condition)
            }
            catch
            {
                // an unexpected error, just throw it right away
                throw error
            }
        }

        //---

        if
            let validatableValue = valueToCheck as? Validatable,
            Specification.performBuiltInValidation
        {
            try checkNestedValidatable(
                value: validatableValue,
                failedConditions: failedConditions
            )
        }
        else
        {
            try justCheckFailedConditions(
                failedConditions,
                with: valueToCheck
            )
        }
    }

    static
    func justCheckFailedConditions(
        _ failedConditions: [String],
        with checkedValue: Value
        ) throws
    {
        if
            !failedConditions.isEmpty
        {
            throw ValidationError.valueIsNotValid(
                origin: displayName,
                value: checkedValue,
                failedConditions: failedConditions,
                report: Specification.prepareReport(
                    value: checkedValue,
                    failedConditions: failedConditions,
                    builtInValidationIssues: [],
                    suggestedReport: Specification.defaultValidationReport(
                        with: failedConditions
                    )
                )
            )
        }
    }

    static
    func checkNestedValidatable(
        value validatableValueToCheck: Validatable,
        failedConditions: [String]
        ) throws
    {
        do
        {
            try validatableValueToCheck.validate()
        }
        catch ValidationError.entityIsNotValid(_, let issues, let report)
        {
            throw reportNestedValidationFailed(
                checkedValue: validatableValueToCheck,
                failedConditions: failedConditions,
                builtInValidationIssues: issues,
                builtInReport: report
            )
        }
        catch let error as ValidationError
        {
            throw reportNestedValidationFailed(
                checkedValue: validatableValueToCheck,
                failedConditions: failedConditions,
                builtInValidationIssues: [error],
                builtInReport: nil
            )
        }
        catch
        {
            // an unexpected error, just throw it right away
            throw error
        }
    }

    static
    func reportNestedValidationFailed(
        checkedValue: Validatable,
        failedConditions: [String],
        builtInValidationIssues: [ValidationError],
        builtInReport: (title: String, message: String)?
        ) -> ValidationError
    {
        let baseReport = Specification
            .defaultValidationReport(with: failedConditions)

        let finalReport = builtInReport
            .map{(
                title: baseReport.title,
                message: """
                \(baseReport.message)
                ———
                \($0.message)
                ———
                """
                )}
            ?? baseReport

        //---

        return .nestedValidationFailed(
            origin: displayName,
            value: checkedValue,
            failedConditions: failedConditions,
            builtInValidationIssues: builtInValidationIssues,
            report: Specification.prepareReport(
                value: checkedValue,
                failedConditions: failedConditions,
                builtInValidationIssues: builtInValidationIssues,
                suggestedReport: finalReport
            )
        )
    }
}
