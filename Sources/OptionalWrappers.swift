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
 satisfies all conditions from custom provided Specification.
 */
public
struct OptionalCustom<T>: OptionalValueWrapper,
    WithCustomValue
    where
    T: ValueSpecification,
    T.Value: Codable & Equatable
{
    public
    typealias Specification = T

    public
    static
    var displayName: String { return Specification.displayName }

    public
    var value: Specification.Value?

    public
    init() {}
}

//---

/**
 Analogue of jsut having 'Swift.Optional',
 but allows to unify API for dealing with entities.
 */
public
struct OptionalBasic<T>: OptionalValueWrapper
    // nothing to validate!
    where
    T: Codable & Equatable
{
    public
    typealias Value = T

    public
    var value: Value?

    public
    init() {}
}
