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
extension Swift.Optional
    where
    Wrapped: Validatable & ValueWrapper & AutoValidValue
{
    // see various implementations below
}

//---

public
extension Swift.Optional
    where
    Wrapped: Validatable & ValueWrapper & AutoValidValue
{
    public
    func validValue() throws -> Value // NON-Mandatory!
    {
        switch self
        {
            case .none:
                return nil // 'nil' is allowed

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }

    public
    func validValue(
        _ collectError: inout [ValidationError]
        ) throws -> Value // NON-Mandatory!
    {
        do
        {
            try validate()
        }
        catch let error as ValidationError
        {
            collectError.append(error)
        }
        catch
        {
            // an unexpected error should be thrown to the upper level
            throw error
        }

        //---

        return value // just return value regardless of its validity!
    }
}

//---

public
extension Swift.Optional
    where
    Wrapped: Mandatory, // <<<---
    Wrapped: Validatable & ValueWrapper & AutoValidValue
{
    func validValue() throws -> Wrapped.Value // Mandatory!
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
                        suggestedReport: Wrapped.defaultEmptyValueReport
                    )
                )

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }

    /**
     This is a special getter that allows to get an optional valid value
     OR collect an error, if stored value is invalid.
     This helper function allows to collect issues from multiple
     validateable values wihtout throwing an error immediately,
     but received value should ONLY be used/read if the 'collectError'
     is empty in the end.
     */
    func validValue(
        _ collectError: inout [ValidationError]
        ) throws -> Wrapped.Value! // Mandatory, implicitly unwrapped!
    {
        do
        {
            // NOTE: withing explicit result type
            // it goes to a wrong version of the 'validValue()' func!
            let result: Wrapped.Value = try validValue()

            return result
        }
        catch let error as ValidationError
        {
            collectError.append(error)

            //---

            return nil
        }
        catch
        {
            // an unexpected error should be thrown to the upper level
            throw error
        }
    }
}
