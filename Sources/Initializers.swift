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

// MARK: - Mandatory + Validator

public
extension ValueValidator
    where
    Self: DisplayNamed,
    Self.Input: Codable & Equatable
{
    typealias ValidatableWrapper =
        CustomValidatableMandatoryValue<Self>

    //---

    static
    func wrapped(
        ) -> ValidatableWrapper
    {
        return ValidatableWrapper()
    }

    static
    func wrapped(
        initialValue value: Self.Input
        ) -> ValidatableWrapper
    {
        return ValidatableWrapper(initialValue: value)
    }

    static
    func wrapped(
        const value: Self.Input
        ) throws -> ValidatableWrapper
    {
        return try ValidatableWrapper(const: value)
    }
}

// MARK: - Mandatory + Context

public
extension Equatable
    where
    Self: Codable
{
    typealias ContextualValidatableWrapper<NP: DisplayNamed> =
        ContextualValidatableMandatoryValue<NP, Self>

    //---

    //swiftlint:disable identifier_name

    static
    func wrapped<NP: DisplayNamed>(
        as: NP.Type
        ) -> ContextualValidatableWrapper<NP>
    {
        return ContextualValidatableWrapper<NP>()
    }

    static
    func wrapped<NP: DisplayNamed>(
        as: NP.Type,
        initialValue value: Self
        ) -> ContextualValidatableWrapper<NP>
    {
        return ContextualValidatableWrapper<NP>(initialValue: value)
    }

    static
    func wrapped<NP: DisplayNamed>(
        as: NP.Type,
        const value: Self
        ) throws -> ContextualValidatableWrapper<NP>
    {
        return try ContextualValidatableWrapper<NP>(const: value)
    }

    //---

    func wrapped<NP: DisplayNamed>(
        as: NP.Type
        ) -> ContextualValidatableWrapper<NP>
    {
        return ContextualValidatableWrapper<NP>(initialValue: self)
    }

    func wrappedConst<NP: DisplayNamed>(
        as: NP.Type
        ) throws -> ContextualValidatableWrapper<NP>
    {
        return try ContextualValidatableWrapper<NP>(const: self)
    }

    //swiftlint:enable identifier_name
}

// MARK: - Mandatory

public
extension Equatable
    where
    Self: Codable,
    Self: DisplayNamed
{
    typealias ValidatableWrapper = ValidatableMandatoryValue<Self>

    //---

    static
    func wrapped(
        ) -> ValidatableWrapper
    {
        return ValidatableWrapper()
    }

    static
    func wrapped(
        initialValue value: Self
        ) -> ValidatableWrapper
    {
        return ValidatableWrapper(initialValue: value)
    }

    static
    func wrapped(
        const value: Self
        ) throws -> ValidatableWrapper
    {
        return try ValidatableWrapper(const: value)
    }

    //---

    func wrapped(
        ) -> ValidatableWrapper
    {
        return ValidatableWrapper(initialValue: self)
    }

    func wrappedConst(
        ) throws -> ValidatableWrapper
    {
        return try ValidatableWrapper(const: self)
    }
}

// MARK: - Optional + Validator

public
extension Swift.Optional
    where
    Wrapped: ValueValidator,
    Wrapped: DisplayNamed,
    Wrapped.Input: Codable & Equatable
{
    typealias CustomValidatableWrapper =
        CustomValidatableOptionalValue<Wrapped>

    //---

    static
    func wrapped(
        ) -> CustomValidatableWrapper
    {
        return CustomValidatableWrapper()
    }

    static
    func wrapped(
        initialValue value: Wrapped.Input
        ) -> CustomValidatableWrapper
    {
        return CustomValidatableWrapper(initialValue: value)
    }

    static
    func wrapped(
        const value: Wrapped.Input
        ) throws -> CustomValidatableWrapper
    {
        return try CustomValidatableWrapper(const: value)
    }
}

// MARK: - Optional + Context

public
extension Swift.Optional
    where
    Wrapped: Codable & Equatable
{
    typealias ContextualWrapper<NP: DisplayNamed> =
        ContextualOptionalValue<NP, Wrapped>

    //---

    //swiftlint:disable identifier_name

    static
    func wrapped<NP: DisplayNamed>(
        as: NP.Type
        ) -> ContextualWrapper<NP>
    {
        return ContextualWrapper<NP>()
    }

    static
    func wrapped<NP: DisplayNamed>(
        as: NP.Type,
        initialValue value: Wrapped
        ) -> ContextualWrapper<NP>
    {
        return ContextualWrapper<NP>(initialValue: value)
    }

    //---

    func wrapped<NP: DisplayNamed>(
        as: NP.Type
        ) -> ContextualWrapper<NP>
    {
        switch self
        {
            case .none:
                return ContextualWrapper<NP>()

            case .some(let value):
                return ContextualWrapper<NP>(initialValue: value)
        }
    }

    //swiftlint:enable identifier_name
}

// MARK: - Optional

public
extension Swift.Optional
    where
    Wrapped: Codable & Equatable,
    Wrapped: DisplayNamed
{
    typealias Wrapper = OptionalValue<Wrapped>

    //---

    static
    func wrapped(
        ) -> Wrapper
    {
        return Wrapper()
    }

    static
    func wrapped(
        initialValue value: Wrapped
        ) -> Wrapper
    {
        return Wrapper(initialValue: value)
    }

    //---

    func wrapped(
        ) -> Wrapper
    {
        switch self
        {
            case .none:
                return Wrapper()

            case .some(let value):
                return Wrapper(initialValue: value)
        }
    }
}
