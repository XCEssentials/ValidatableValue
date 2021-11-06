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

// MARK: - Validation

extension Swift.Optional: SomeValidatable where Wrapped: SomeValidatableValueWrapper
{
    public
    func validate() throws
    {
        switch self
        {
            case .none where Wrapped.self is Mandatory:
                
                throw ValidationError.requiredValueIsMissing
                
            case .none:
                
                break // it's okay to be missing for non-Mandatory wrappers
                
            case .some(let wrapped):
                
                try wrapped.validate()
        }
    }
}

extension Swift.Optional where Wrapped: SomeValidatableValueWrapper & Mandatory
{
    public
    var validValue: Wrapped.Value.Valid
    {
        get throws {
           
            switch self
            {
                case .none:
                    
                    throw ValidationError.requiredValueIsMissing
                    
                case .some(let wrapped):
                    
                    return try wrapped.validValue
            }
        }
    }
}

// MARK: - Metadata

public
typealias ValidatableValueWrapperMetadata = (
    isEmpty: Bool,
    isMandatory: Bool,
    isValid: Bool
)

public
extension Swift.Optional where Wrapped: SomeValidatableValueWrapper
{
    var metadata: ValidatableValueWrapperMetadata
    {
        return (
            self == nil,
            self is Mandatory,
            self.isValid
        )
    }
}
