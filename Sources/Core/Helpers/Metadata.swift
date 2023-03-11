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

// MARK: - Metadata

public
typealias ValidatationMetadata = (
    isSecret: Bool,
    isEmpty: Bool,
    isRequired: Bool,
    isValid: Bool
)

public
protocol WithValidationMetadata
{
    var metadata: ValidatationMetadata { get }
}

//---

extension SomeNonRequiredValueWrapper
{
    public
    var metadata: ValidatationMetadata
    {
        return (
            type(of: self).isSecret,
            isEmpty,
            false,
            isValid
        )
    }
}

//---

extension SomeRequiredValueWrapper
{
    public
    var metadata: ValidatationMetadata
    {
        return (
            type(of: self).isSecret,
            isEmpty,
            true,
            isValid
        )
    }
}

//---

extension Swift.Optional: WithValidationMetadata where Wrapped: SomeNonRequiredValueWrapper
{
    public
    var metadata: ValidatationMetadata
    {
        return (
            Wrapped.isSecret,
            map { $0.isEmpty } ?? true,
            false,
            map { $0.isValid } ?? false
        )
    }
}

//---

extension Swift.Optional where Wrapped: SomeRequiredValueWrapper
{
    public
    var metadata: ValidatationMetadata
    {
        return (
            Wrapped.isSecret,
            map { $0.isEmpty } ?? true,
            true,
            isValid
        )
    }
}
