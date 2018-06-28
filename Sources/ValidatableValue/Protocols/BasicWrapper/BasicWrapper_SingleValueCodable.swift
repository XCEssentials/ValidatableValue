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
 Special trait for 'BasicValueWrapper' protocol that allows to customize
 'Codable' protocol support and make the wrapper encode and decode itself
 as a single value (because the only important thing stored inside wrapper
 is teh value anyway, everything else belongs to type leve, not instance level).
 Without this trait wrapper will rely on implicit 'Codable' support
 provided by Swift itself and will be encoded as object/dictionary
 with single entry (which is unnecessary complication): "{\"value\": \"XXX\"}"
 */
public
protocol SingleValueCodable: BasicValueWrapper, Trait {}

//---

public
extension SingleValueCodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()

        //---
        
        try container.encode(value)
    }

    init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()

        //---

        self.init(wrappedValue: try container.decode(Value.self))
    }
}
