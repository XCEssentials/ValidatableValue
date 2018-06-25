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

// MARK: - Validatable support

// public
extension Swift.Optional: Validatable
    where
    Wrapped: Validatable
{
    public
    func validate() throws
    {
        if
            case .some(let validatable) = self
        {
            try validatable.validate()
        }
    }
}

// MARK: - Validatable support - when wrap Mandatory & ValueWrapper

public
extension Swift.Optional // : Validatable
    where
    Wrapped: Mandatory & Validatable & ValueWrapper
{
    public
    func validate() throws
    {
        // throw if no value!
        // or pass validation to the non-empty value
        switch self
        {
            case .none:
                throw ValidationError.mandatoryValueIsNotSet(
                    origin: displayName,
                    report: Wrapped.defaultEmptyValueReport
                )

            case .some(let validatable):
                try validatable.validate()
        }
    }
}

// MARK: - Validatable support - when wrap Mandatory & CustomValueWrapper

public
extension Swift.Optional // : Validatable
    where
    Wrapped: Mandatory & CustomValueWrapper
{
    public
    func validate() throws
    {
        // throw if no value!
        // or pass validation to the non-empty value
        switch self
        {
            case .none:
                throw Wrapped.reportEmptyValue()

            case .some(let validatable):
                try validatable.validate()
        }
    }
}

// MARK: - Convenient helpers

public
extension Optional
    where
    Wrapped: Validatable & ValueWrapper
{
    func validValue() throws -> Wrapped.Value?
    {
        switch self
        {
            case .none:
                return nil

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }
}

// MARK: - Convenient helpers + Mandatory

public
extension Optional
    where
    Wrapped: Mandatory & Validatable & ValueWrapper
{
    func validValue() throws -> Wrapped.Value?
    {
        switch self
        {
            case .none:
                throw ValidationError.mandatoryValueIsNotSet(
                    origin: displayName,
                    report: Wrapped.defaultEmptyValueReport
                )

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }
}

// MARK: - Convenient helpers + Mandatory + Custom

public
extension Optional
    where
    Wrapped: Mandatory & CustomValueWrapper
{
    func validValue() throws -> Wrapped.Value?
    {
        switch self
        {
            case .none:
                throw Wrapped.reportEmptyValue()

            case .some(let wrapper):
                return try wrapper.validValue()
        }
    }
}

//---

//extension Swift.Optional
//    where
//    Wrapped: Validatable & ValueWrapper
//{
//    /**
//     Convenience initializer useful for setting a 'let' value,
//     that only should be set once during initialization. Assigns
//     provided value and validates it right away.
//     */
//    init(
//        withValidatable value: Wrapped.Value?
//        ) throws
//    {
//        self = value.map{ .some(.init($0)) } ?? .none
//
//        //---
//
//        try self.validate()
//    }
//
//    /**
//     Set new value and validate it in single operation.
//     */
//    mutating
//    func set(_ newValue: Wrapped.Value?) throws
//    {
//        value = newValue
//        try validate()
//    }
//
//    /**
//     Validate a given value without actually setting it as current value.
//     */
//    func validate(value: Wrapped.Value?) throws
//    {
//        var tmp = self
//        try tmp.set(value)
//    }
//}
