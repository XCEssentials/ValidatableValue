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
func << <VV, T>(
    container: inout VV,
    newValue: T
    ) throws
    where
    VV: SomeValidatableValue,
    VV.Specification.RawValue == T
{
    try container.set(newValue)
}

//---

public
func << <VV, T>(
    container: inout VV?, // optional support!
    newValue: T?
    ) throws
    where
    VV: SomeValidatableValue,
    VV.Specification.RawValue == T
{
    try container.set(newValue)
}

//---

infix operator <?

//---

public
func <? <VV, T>(
    container: inout VV,
    newValue: T
    )
    where
    VV: SomeValidatableValue,
    VV.Specification.RawValue == T
{
    container = newValue.wrapped()
}

//---

public
func <? <VV, T>(
    container: inout VV?,
    newValue: T?
    )
    where
    VV: SomeValidatableValue,
    VV.Specification.RawValue == T
{
    container = newValue.map{ .some($0.wrapped()) } ?? .none
}

//---

public
func == <VV, T>(
    container: VV,
    value: T?
    ) -> Bool
    where
    VV: Equatable,
    T: Equatable,
    VV: SomeValidatableValue,
    VV.Specification.RawValue == T
{
    return container.rawValue == value
}

public
func == <VV, T>(
    value: T?,
    container: VV
    ) -> Bool
    where
    VV: Equatable,
    T: Equatable,
    VV: SomeValidatableValue,
    VV.Specification.RawValue == T
{
    return container.rawValue == value
}
