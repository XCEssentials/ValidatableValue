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

import Foundation

/**
 It considers as 'valid' either 'nil' or non-'nil' 'value' that
 satisfies all conditions from custom provided Validator.
 'V' stands for 'Validator'.
 */
public
struct CustomValidatableOptionalValue<V>: ValueWrapper,
    Optional,
    CustomValidatable,
    DisplayNamed
    where
    V: ValueValidator,
    V: DisplayNamed,
    V.Input: Codable,
    V.Input: Equatable
{
    public
    typealias Value = V.Input

    public
    typealias Validator = V

    public
    static
    var displayName: String { return V.displayName }

    public
    var value: V.Input?

    public
    init() {}
}

//---

/**
 Analogue of jsut having 'Swift.Optional',
 but allows to unify API for dealing with entities.
 'NP' stands for '(Display) Name Provider'.
 'I' stands for 'Input'.
 */
public
struct ContextualOptionalValue<NP, I>: ValueWrapper,
    Optional,
    // nothing to validate!
    DisplayNamed
    where
    NP: DisplayNamed,
    I: Codable,
    I: Equatable
{
    public
    typealias Value = I

    public
    static
    var displayName: String { return NP.displayName }

    public
    var value: I?

    public
    init() {}
}

//---

/**
 Analogue of jsut having 'Swift.Optional',
 but allows to unify API for dealing with entities.
 'I' stands for 'Input'.
 */
public
struct OptionalValue<I>: ValueWrapper,
    Optional,
    // nothing to validate!
    DisplayNamed
    where
    I: DisplayNamed,
    I: Codable,
    I: Equatable
{
    public
    typealias Value = I

    public
    static
    var displayName: String { return I.displayName }

    public
    var value: I?

    public
    init() {}
}
