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
protocol MandatoryValidatable: ValidatableValue { }

// MARK: - Custom members

public
extension MandatoryValidatable
{
    public
    var value: Value!
    {
        return try? valueIfValid()
    }
    
    public
    func valueIfValid() throws -> Value
    {
        if
            let result = draft
        {
            // non-'nil' draft value must be checked againts requirements
            
            try type(of: self).validations.forEach
            {
                try $0.perform(with: result)
            }
            
            //---
            
            return result
        }
        else
        {
            // 'draft' is 'nil', which is NOT allowed
            
            throw ValidatableValueError.valueNotSet
        }
    }
}

// MARK: - Validatable support

public
extension MandatoryValidatable
{
    public
    var isValid: Bool
    {
        do
        {
            _ = try valueIfValid()
            
            return true
        }
        catch
        {
            return false
        }
    }
    
    public
    func validate() throws
    {
        _ = try valueIfValid()
    }
}

// MARK: - Extra helpers

public
extension MandatoryValidatable
{
    @discardableResult
    func mapValid<U>(_ transform: (Value) throws -> U) rethrows -> U?
    {
        return try (try? valueIfValid()).map(transform)
    }
    
    @discardableResult
    func flatMapValid<U>(_ transform: (Value) throws -> U?) rethrows -> U?
    {
        return try (try? valueIfValid()).flatMap(transform)
    }
}
