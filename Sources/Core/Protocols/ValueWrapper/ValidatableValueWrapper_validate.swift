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
extension SomeValidatableValueWrapper
{
    func validate() throws
    {
        try type(of: self).check(rawValue)
    }
}

// MARK: - Convenience validation helpers

public
extension SomeValidatableValueWrapper
{
    /**
     Convenience initializer initializes wrapper and validates it
     right away.
     */
    init(
        validate value: Specification.RawValue
        ) throws
    {
        self.init(wrappedValue: value)
        try self.validate()
    }

    /**
     Validate a given value without saving it.
     */
    static
    func validate(
        value: Specification.RawValue
        ) throws
    {
        _ = try Self.init(validate: value)
    }

    /**
     Set new value and validate it in single operation.
     */
    mutating
    func set(
        _ newValue: Specification.RawValue
        ) throws
    {
        rawValue = newValue
        try validate()
    }
}


// MARK: - Private validation helpers

private
extension SomeValidatableValueWrapper
{
    static
    func check(_ valueToCheck: Specification.RawValue) throws
    {
        let failedConditions = try Specification.failedConditions(for: valueToCheck)

        //---

        if
            let validatableValue = valueToCheck as? SomeValidatable,
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
        with checkedValue: Specification.RawValue
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
        value validatableValueToCheck: SomeValidatable,
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
        checkedValue: SomeValidatable,
        failedConditions: [String],
        builtInValidationIssues: [Error],
        builtInReport: (title: String, message: String)?
        ) -> Error
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

        return ValidationError.nestedValidationFailed(
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
