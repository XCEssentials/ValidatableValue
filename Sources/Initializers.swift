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

// MARK: - MandatoryValueWrapper

public
extension Equatable
    where
    Self: Codable
{
    typealias ValidatableWrapper = MandatoryWrapped<Self>

    static
    func validatable() -> ValidatableWrapper
    {
        return ValidatableWrapper()
    }

    static
    func validatable(initialValue value: Self) -> ValidatableWrapper
    {
        return ValidatableWrapper(initialValue: value)
    }

    static
    func validatable(const value: Self) throws -> ValidatableWrapper
    {
        return try ValidatableWrapper(const: value)
    }

    func validatable() -> ValidatableWrapper
    {
        return ValidatableWrapper(initialValue: self)
    }

    func validatableConst() throws -> ValidatableWrapper
    {
        return try ValidatableWrapper(const: self)
    }
}

// MARK: - MandatoryValueWrapper + Validator

public
extension ValueValidator
    where
    Self.Input: Codable & Equatable
{
    typealias ValidatableWrapper = MandatoryValidatableWrapped<Self>

    static
    func validatable() -> ValidatableWrapper
    {
        return ValidatableWrapper()
    }

    static
    func validatable(initialValue value: Self.Input) -> ValidatableWrapper
    {
        return ValidatableWrapper(initialValue: value)
    }

    static
    func validatable(const value: Self.Input) throws -> ValidatableWrapper
    {
        return try ValidatableWrapper(const: value)
    }
}

// MARK: - Optional

public
extension Swift.Optional
    where
    Wrapped: Codable & Equatable
{
    typealias Wrapper = OptionalWrapped<Wrapped>

    static
    func wrapped() -> Wrapper
    {
        return Wrapper()
    }

    static
    func wrapped(initialValue value: Wrapped) -> Wrapper
    {
        return Wrapper(initialValue: value)
    }
}

// MARK: - Optional + Validator

public
extension Swift.Optional
    where
    Wrapped: ValueValidator,
    Wrapped.Input: Codable & Equatable
{
    typealias ValidatableWrapper = OptionalValidatableWrapped<Wrapped>

    static
    func validatable() -> ValidatableWrapper
    {
        return ValidatableWrapper()
    }

    static
    func validatable(initialValue value: Wrapped.Input) -> ValidatableWrapper
    {
        return ValidatableWrapper(initialValue: value)
    }

    static
    func validatable(const value: Wrapped.Input) throws -> ValidatableWrapper
    {
        return try ValidatableWrapper(const: value)
    }
}
