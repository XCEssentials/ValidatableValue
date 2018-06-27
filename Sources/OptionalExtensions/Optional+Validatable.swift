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
extension Swift.Optional: Validatable
    where
    Wrapped: Validatable
{
    // see various implementations below
}

//---

public
extension Swift.Optional
    where
    Wrapped: Validatable
{
    public
    func validate() throws
    {
        if
            case .some(let validatable) = self
        {
            try validatable.validate()
        }
    }
}

//---

public
extension Swift.Optional
    where
    Wrapped: Validatable & Mandatory
{
    func validate() throws
    {
        switch self
        {
            case .none:
                throw Wrapped.reportEmptyValue()

            case .some(let validatable):
                try validatable.validate()
        }
    }
}

// TODO: Finish this - move to 'Optional' extension!
//public
//extension OptionalValueWrapper
//    where
//    Self: WithCustomValue,
//    Self.Specification.Value == Self.Value
//{
//    /**
//     This is a special getter that allows to get an optional valid value
//     OR collect an error, if stored value is invalid.
//     This helper function allows to collect issues from multiple
//     validateable values wihtout throwing an error immediately,
//     but received value should ONLY be used/read if the 'collectError'
//     is empty in the end.
//     */
//    func validValue(
//        _ accumulateValidationError: inout [ValidationError]
//        ) throws -> Value?
//    {
//        let result: Value?
//
//        //---
//
//        do
//        {
//            result = try validValue()
//        }
//        catch let error as ValidationError
//        {
//            accumulateValidationError.append(error)
//            result = nil
//        }
//        catch
//        {
//            // anything except 'ValueValidationFailed'
//            // should be thrown to the upper level
//            throw error
//        }
//
//        //---
//
//        return result
//    }
//
//    /**
//     It returns whatever is stored in 'value', or
//     throws 'ValidationError' if 'value' is not 'nil'
//     and failed to pass validation.
//     */
//    func validValue() throws -> Value?
//    {
//        guard
//            let result = value
//        else
//        {
//            // 'nil' is allowed
//            return nil
//        }
//
//        //---
//
//        // non-'nil' value must be checked againts requirements
//
//        try checkNonEmptyValue(result)
//
//        //---
//
//        return result
//    }
//}
