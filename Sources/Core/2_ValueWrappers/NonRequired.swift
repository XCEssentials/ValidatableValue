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
 Value stored in this wrapper will be validated acording to the
 provided specification. When this wrapper is optional - the empty
 value ('nil') is considered to be valid.
 */
public
struct NonRequired<T: SomeValidatableValue>: SomeNonRequiredValueWrapper
{
    public
    typealias Value = T

    public
    var rawValue: T.Raw
    {
        didSet
        {
            storage?.store(value: rawValue)
        }
    }
    
    public
    let storage: ValueStorage?
    
    public
    init(_ rawValue: T.Raw)
    {
        self.init(rawValue, storage: nil)
    }
    
    public
    init(_ defaultValue: T.Raw, storage: ValueStorage?)
    {
        self.rawValue = storage?.fetchValue(default: defaultValue) ?? defaultValue
        self.storage = storage
    }
}

// MARK: - Array helpers

public
extension NonRequired where Value.Raw: ExpressibleByArrayLiteral
{
    init() { self.init([]) }
    init(storage: ValueStorage) { self.init([], storage: storage) }
}

// MARK: - String helpers

public
extension NonRequired where Value.Raw: ExpressibleByStringLiteral
{
    init() { self.init("") }
    init(storage: ValueStorage) { self.init("", storage: storage) }
}
