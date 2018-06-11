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

/**
 General purpose value wrapper that can store any
 kind of value inside.
 */
public
protocol ValueWrapperBase: Codable, Equatable // TODO: just 'ValueWrapper'
{
    associatedtype RawValue: Codable, Equatable

    //---

    init()

    var value: RawValue? { get set }
}

// MARK: - Automatic 'Codable' conformance

public
extension ValueWrapperBase
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }

    init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(RawValue.self)

        //---

        self.init()
        self.value = value
    }
}

//---

public
protocol ValueWrapper: ValueWrapperBase, Validatable
{
    associatedtype Validator: ValueValidator where Validator.Input == RawValue
    associatedtype ValidValue

    //---

    /**
     Supposed to evaluate 'value' against all conditions and
     return a valid value or throw an error if any of the conditions
     is not satisfied.
     */
    func valueIfValid() throws -> ValidValue
}

// MARK: - Automatic 'Validatable' conformance

public
extension ValueWrapper
{
    func validate() throws
    {
        _ = try valueIfValid()
    }
}

// MARK: - Convenience helpers

public
extension ValueWrapper
{
    /**
     Convenience initializer that assigns provided value
     as value, does NOT check its validity.
     */
    init(
        initialValue: RawValue
        )
    {
        self.init()
        self.value = initialValue
    }

    /**
     Convenience initializer useful for setting a 'let' value,
     that only should be set once during initialization. Assigns
     provided value and validates it right away.
     */
    init(
        const value: RawValue
        ) throws
    {
        self.init()
        try self.set(value)
    }

    /**
     Set new value and validate it in single operation.
     */
    mutating
    func set(_ newValue: RawValue?) throws
    {
        value = newValue
        try validate()
    }

    /**
     Validate a given value without actually setting it to current value.
     */
    func validate(value: RawValue?) throws
    {
        var tmp = self
        try tmp.set(value)
    }
}
