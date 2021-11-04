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

// public
extension Swift.Optional: SomeValidatable
    where
    Wrapped: SomeValueWrapper
{
    public
    func validate() throws
    {
        if
            let mandatory = Wrapped.self as? Mandatory.Type
        {
            switch self
            {
                case .none:
                    throw ValidationError.mandatoryValueIsNotSet(
                        origin: Wrapped.displayName,
                        report: Wrapped.Specification.prepareReport(
                            value: nil,
                            failedConditions: [],
                            builtInValidationIssues: [],
                            suggestedReport: mandatory.defaultEmptyValueReport
                        )
                    )

                case .some(let validatable):
                    try validatable.validate()
            }
        }
        else
        if
            case .some(let validatable) = self
        {
            try validatable.validate()
        }
    }
}

// MARK: - Convenience helpers

public
extension Swift.Optional
    where
    Wrapped: SomeValueWrapper
{
    /**
     Convenience initializer initializes wrapper and validates it
     right away.
     */
    init(
        validate value: Wrapped.Value?
        ) throws
    {
        self = value.map{ .some($0.wrapped()) } ?? .none
        try self.validate()
    }

    /**
     Validate a given value without saving it.
     */
    static
    func validate(
        value: Wrapped.Value?
        ) throws
    {
        _ = try self.init(validate: value)
    }

    /**
     Set new value and validate it in single operation.
     */
    mutating
    func set(
        _ newValue: Wrapped.Value?
        ) throws
    {
        self = newValue.map{ .some($0.wrapped()) } ?? .none

        //---

        try validate()
    }
}

