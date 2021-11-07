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

public
protocol SomeValidatableValueWrapper: Codable, DisplayNamed
{
    associatedtype Value: SomeValidatableValue
    
    init(rawValue: Value.Raw)

    var rawValue: Value.Raw { get set }
}

// MARK: - DisplayNamed support

public
extension SomeValidatableValueWrapper
{
    static
    var displayName: String
    {
        return Value.displayName
    }

    static
    var displayHint: String?
    {
        return Value.displayHint
    }

    static
    var displayPlaceholder: String?
    {
        return Value.displayPlaceholder
    }
}

// MARK: - Codable support

public
extension SomeValidatableValueWrapper
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()

        //---
        
        try container.encode(rawValue)
    }

    init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()

        //---

        self.init(rawValue: try container.decode(Value.Raw.self))
    }
}

// MARK: - (PRIVATE) Shared functionality

//internal
extension SomeValidatableValueWrapper
{
    func checkConditionsAndConvert() throws -> Value.Valid
    {
        let unsatisfiedConditions: [Error] = Value
            .conditions
            .compactMap {

                do
                {
                    try $0.validate(rawValue)
                    return nil // this condition indicated no issue
                }
                catch
                {
                    return error
                }
            }

        //---

        guard
            unsatisfiedConditions.isEmpty
        else
        {
            throw ValidationError.unsatisfiedConditions(
                unsatisfiedConditions,
                rawValue: rawValue
            )
        }
        
        //---
        
        guard
            let result = Value.convert(rawValue: rawValue)
        else
        {
            throw ValidationError.unableToConvert(rawValue: rawValue)
        }
        
        //---
        
        return result
    }
}
