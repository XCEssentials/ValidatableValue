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

import XCERequirement

//---

/**
 Describes custom value type for a wrapper.
 */
public
protocol SomeValidatableValue: DisplayNamed
{
    associatedtype Raw: Codable

    associatedtype Valid: Codable
    
    /// Helps identify whatever given value considered as empty.
    static
    func isEmpty(rawValue: Raw) -> Bool
    
    /// Specifies how we convert `Raw` into `Valid`.
    ///
    /// Error thrown from this conversion considered to be
    /// validation error as well.
    static
    func convert(rawValue: Raw) -> Valid?
    
    /**
     Set of conditions for the 'Value' which gonna be used
     for value validation.
     */
    static
    var conditions: [Condition<Raw>] { get }
}

// MARK: - Default implementations

public
extension SomeValidatableValue
{
    static
    var conditions: [Condition<Raw>] { [] }
}

public
extension SomeValidatableValue where Raw == Valid
{
    static
    func convert(rawValue: Raw) -> Valid?
    {
        rawValue
    }
}

public
extension SomeValidatableValue where Valid: RawRepresentable, Valid.RawValue == Raw
{
    static
    func convert(rawValue: Raw) -> Valid?
    {
        Valid.init(rawValue: rawValue)
    }
}

public
extension SomeValidatableValue
{
    static
    func isEmpty(rawValue: Raw) -> Bool
    {
        false
    }
}

public
extension SomeValidatableValue where Raw: Collection
{
    static
    func isEmpty(rawValue: Raw) -> Bool
    {
        rawValue.isEmpty
    }
}
