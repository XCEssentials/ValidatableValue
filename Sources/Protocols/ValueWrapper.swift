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
protocol ValueWrapper: Codable, Equatable, InstanceReferable
{
    associatedtype Value: Codable, Equatable

    //---

    /**
     Wrapper must be initializable without any parameters.
     */
    init()

    /**
     This value will be used for 'reference' value, which,
     in turn, will be used for reference to this wrapper
     from the errors thrown during validation, so it's easy
     later to identify origin of any error.
     */
    var identifier: String { get }

    /**
     Teh value that this wrapper is storing.
     */
    var value: Value? { get set }
}

// MARK: - InstanceReferable conformance

public
extension ValueWrapper
{
    var reference: ValueInstanceReference
    {
        return ValueInstanceReference(
            identifier: identifier,
            type: type(of: self)
        )
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
        initialValue: Value
        )
    {
        self.init()
        self.value = initialValue
    }
}

// MARK: - Automatic 'Codable' conformance

public
extension ValueWrapper
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }

    init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Value.self)

        //---

        self.init()
        self.value = value
    }
}
