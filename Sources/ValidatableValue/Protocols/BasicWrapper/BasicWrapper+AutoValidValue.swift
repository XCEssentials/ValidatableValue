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
protocol AutoValidValue: Trait {}

//---

public
extension BasicValueWrapper
    where
    Self: Validatable & AutoValidValue
{
    func validValue(
        ) throws -> Self.Value
    {
        try validate()

        //---

        return value
    }

    /**
     Validates and returns 'value' regardless of its validity,
     puts any encountered validation errors in the 'collectError'
     array. Any unexpected occured error (except 'ValidationError')
     will be thrown immediately.
     */
    func validValue(
        _ collectError: inout [ValidationError]
        ) throws -> Self.Value
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

        return value // return value regardless of its validity!
    }
}
