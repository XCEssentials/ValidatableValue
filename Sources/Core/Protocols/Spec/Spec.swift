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
protocol ValueSpecification: DisplayNamed
{
    associatedtype Value: Codable & Equatable

    /**
     Set of conditions for the 'Value' which gonna be used
     for value validation.
     */
    static
    var conditions: [Condition<Value>] { get }

    /**
     This closure allows to customize/override default validation
     failure reports. This is helpful to add/set some custom copy
     to the report, including for localization purposes.
     */
    static
    var reviewReport: ValueReportReview { get }
}

// MARK: - Default implementations

public
extension ValueSpecification
{
    static
    var conditions: [Condition<Value>]
    {
        return []
    }

    static
    var reviewReport: ValueReportReview
    {
        return { _, _ in }
    }
}
