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
extension SomeValidatableValue
    where
    Self: NonMandatory // <<<--- NON-mandatory only!
{
    var validValue: Self.Specification.ValidValue?
    {
        get throws {
            
            try validate()

            //---

            return Specification.convert(rawValue: rawValue)
        }
    }

    /**
     Validates and returns 'value' regardless of its validity,
     puts any encountered validation errors in the 'collectError'
     array.
     */
    func validValue(
        _ collectError: inout [Error]
        ) throws -> Self.Specification.ValidValue?
    {
        do
        {
            return try validValue
        }
        catch
        {
            collectError.append(error)
            return nil
        }
    }
}

// MARK: - Optional extensions

public
extension Swift.Optional
    where
    Wrapped: SomeValidatableValue & Mandatory // <<<---
{
    var validValue: Wrapped.Specification.ValidValue? // Mandatory!
    {
        get throws {
            
            switch self
            {
            case .none:
                throw ValidationError.mandatoryValueIsNotSet(
                    origin: Wrapped.displayName,
                    report: Wrapped.Specification.prepareReport(
                        value: nil,
                        failedConditions: [],
                        builtInValidationIssues: [],
                        suggestedReport: Wrapped.defaultEmptyValueReport
                    )
                )

            case .some(let wrapper):
                try wrapper.validate()
                return Wrapped.Specification.convert(rawValue: wrapper.rawValue)
            }
        }
    }

    /**
     CAREFUL!!! The result is implicitly unwrapped optional!
     This is a special getter that allows to get an optional valid value
     OR collect an error, if stored value is invalid.
     This helper function allows to collect issues from multiple
     validateable values wihtout throwing an error immediately,
     but received value should ONLY be used/read if the 'collectError'
     is empty in the end.
     */
    func validValue(
        _ collectError: inout [Error]
        ) -> Wrapped.Specification.ValidValue? // Mandatory
    {
        do
        {
            return try validValue
        }
        catch
        {
            collectError.append(error)
            return nil
        }
    }
}
