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
    where
    Self: Validatable
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

// MARK: - Reporting

extension ValueWrapper
    where
    Self: WithCustomValue,
    Self.Specification.Value == Self.Value
{
    func checkNonEmptyValue(
        _ nonEmptyValue: Value
        ) throws
    {
        var failedConditions: [String] = []

        try Specification.conditions.forEach
        {
            do
            {
                try $0.validate(value: nonEmptyValue)
            }
            catch let error as ConditionUnsatisfied
            {
                failedConditions.append(error.condition)
            }
            catch
            {
                // unexpected error, just throw it right away
                throw error
            }
        }

        //---

        if
            let validatableValue = nonEmptyValue as? Validatable,
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
                with: nonEmptyValue
            )
        }
    }

    private
    func justCheckFailedConditions(
        _ failedConditions: [String],
        with nonEmptyValue: Value
        ) throws
    {
        if
            !failedConditions.isEmpty
        {
            throw ValidationError.valueIsNotValid(
                origin: displayName,
                value: nonEmptyValue,
                failedConditions: failedConditions,
                report: Specification.prepareReport(
                    value: nonEmptyValue,
                    failedConditions: failedConditions,
                    builtInValidationIssues: [],
                    suggestedReport: Specification.defaultValidationReport(
                        with: failedConditions
                    )
                )
            )
        }
    }

    private
    func checkNestedValidatable(
        value validatableValue: Validatable,
        failedConditions: [String]
        ) throws
    {
        do
        {
            try validatableValue.validate()
        }
        catch ValidationError.entityIsNotValid(_, let issues, let report)
        {
            throw reportNestedValidationFailed(
                value: validatableValue,
                failedConditions: failedConditions,
                builtInValidationIssues: issues,
                builtInReport: report
            )
        }
        catch let error as ValidationError
        {
            throw reportNestedValidationFailed(
                value: validatableValue,
                failedConditions: failedConditions,
                builtInValidationIssues: [error],
                builtInReport: nil
            )
        }
        catch
        {
            throw error
        }
    }

    private
    func reportNestedValidationFailed(
        value: Validatable,
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
            value: value,
            failedConditions: failedConditions,
            builtInValidationIssues: builtInValidationIssues,
            report: Specification.prepareReport(
                value: value,
                failedConditions: failedConditions,
                builtInValidationIssues: builtInValidationIssues,
                suggestedReport: finalReport
            )
        )
    }
}
