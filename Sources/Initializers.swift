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

// MARK: - Mandatory

public
extension Equatable
    where
    Self: Codable
{
    static
    func validatable() -> MandatoryWrapped<Self>
    {
        return MandatoryWrapped<Self>()
    }

    static
    func validatable(initialValue value: Self) -> MandatoryWrapped<Self>
    {
        return MandatoryWrapped<Self>(initialValue: value)
    }

    static
    func validatable(const value: Self) throws -> MandatoryWrapped<Self>
    {
        return try MandatoryWrapped<Self>(const: value)
    }

    func validatable() -> MandatoryWrapped<Self>
    {
        return MandatoryWrapped(initialValue: self)
    }

    func validatableConst() throws -> MandatoryWrapped<Self>
    {
        return try MandatoryWrapped<Self>(const: self)
    }
}

// MARK: - Mandatory + Validator

public
extension ValueValidator
    where
    Self.Input: Codable & Equatable
{
    static
    func validatable() -> MandatoryValidatableWrapped<Self>
    {
        return MandatoryValidatableWrapped<Self>()
    }

    static
    func validatable(initialValue value: Self.Input) -> MandatoryValidatableWrapped<Self>
    {
        return MandatoryValidatableWrapped<Self>(initialValue: value)
    }

    static
    func validatable(const value: Self.Input) throws -> MandatoryValidatableWrapped<Self>
    {
        return try MandatoryValidatableWrapped<Self>(const: value)
    }
}

// MARK: - Optional

public
extension Swift.Optional
    where
    Wrapped: Codable & Equatable
{
    static
    func wrapped() -> OptionalWrapped<Wrapped>
    {
        return OptionalWrapped<Wrapped>()
    }

    static
    func wrapped(initialValue value: Wrapped) -> OptionalWrapped<Wrapped>
    {
        return OptionalWrapped<Wrapped>(initialValue: value)
    }
}

// MARK: - Optional + Validator

public
extension Swift.Optional
    where
    Wrapped: ValueValidator,
    Wrapped.Input: Codable & Equatable
{
    static
    func validatable() -> OptionalValidatableWrapped<Wrapped>
    {
        return OptionalValidatableWrapped<Wrapped>()
    }

    static
    func validatable(initialValue value: Wrapped.Input) -> OptionalValidatableWrapped<Wrapped>
    {
        return OptionalValidatableWrapped<Wrapped>(initialValue: value)
    }

    static
    func validatable(const value: Wrapped.Input) throws -> OptionalValidatableWrapped<Wrapped>
    {
        return try OptionalValidatableWrapped<Wrapped>(const: value)
    }
}
