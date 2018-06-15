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

// MARK: - Mandatory + Specification

public
extension ValueSpecification
    where
    Self.Value: Codable & Equatable
{
    typealias Wrapper = MandatoryCustom<Self>

    //---

    static
    func wrapped(
        ) -> Wrapper
    {
        return Wrapper()
    }

    static
    func wrapped(
        initialValue value: Self.Value
        ) -> Wrapper
    {
        return Wrapper(initialValue: value)
    }

    static
    func wrapped(
        const value: Self.Value
        ) throws -> Wrapper
    {
        return try Wrapper(const: value)
    }
}

// MARK: - Mandatory

public
extension Equatable
    where
    Self: Codable
{
    typealias Wrapper = MandatoryBasic<Self>

    //---

    static
    func wrapped(
        ) -> Wrapper
    {
        return Wrapper()
    }

    static
    func wrapped(
        initialValue value: Self
        ) -> Wrapper
    {
        return Wrapper(initialValue: value)
    }

    static
    func wrapped(
        const value: Self
        ) throws -> Wrapper
    {
        return try Wrapper(const: value)
    }

    //---

    func wrapped(
        ) -> Wrapper
    {
        return Wrapper(initialValue: self)
    }

    func wrappedConst(
        ) throws -> Wrapper
    {
        return try Wrapper(const: self)
    }
}

// MARK: - Optional + Specification

public
extension Swift.Optional
    where
    Wrapped: ValueSpecification,
    Wrapped.Value: Codable & Equatable
{
    typealias Wrapper = OptionalCustom<Wrapped>

    //---

    static
    func wrapped(
        ) -> Wrapper
    {
        return Wrapper()
    }

    static
    func wrapped(
        initialValue value: Wrapped.Value
        ) -> Wrapper
    {
        return Wrapper(initialValue: value)
    }

    static
    func wrapped(
        const value: Wrapped.Value
        ) throws -> Wrapper
    {
        return try Wrapper(const: value)
    }
}

// MARK: - Optional

public
extension Swift.Optional
    where
    Wrapped: Codable & Equatable
{
    /**
     Unlike all other wrappers, this one does not provide
     validation functionality.
     */
    typealias PassiveWrapper = OptionalBasic<Wrapped>

    //---

    static
    func wrapped(
        ) -> PassiveWrapper
    {
        return PassiveWrapper()
    }

    static
    func wrapped(
        initialValue value: Wrapped
        ) -> PassiveWrapper
    {
        return PassiveWrapper(initialValue: value)
    }

    //---

    func wrapped(
        ) -> PassiveWrapper
    {
        switch self
        {
            case .none:
                return PassiveWrapper()

            case .some(let value):
                return PassiveWrapper(initialValue: value)
        }
    }
}
