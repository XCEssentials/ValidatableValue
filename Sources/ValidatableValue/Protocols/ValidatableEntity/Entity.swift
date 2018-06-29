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
 Data model type that supposed to store all important data
 in various validatable value properties. Such properties will be automatically
 checked for validity each time when whole entity is being tested for validity.
 Those property will be also automatically encoded and decoded.
 */
public
protocol ValidatableEntity: Codable & Equatable,
    DisplayNamed,
    Validatable
{
    /**
     This closure allows to customize/override default validation
     failure reports. This is helpful to add/set some custom copy
     to the report, including for localization purposes.
     */
    static
    var reviewReport: EntityReportReview { get }
}

// MARK: - Default implementations

public
extension ValidatableEntity
{
    static
    var reviewReport: EntityReportReview
    {
        return { _, _ in }
    }
}

// MARK: - Convenience helpers

public
extension ValidatableEntity
{
    var allMembers: [Any]
    {
        return Mirror(reflecting: self)
            .children
            .map{ $0.value }
    }

    var allValidatableMembers: [Validatable]
    {
        return Mirror(reflecting: self)
            .children
            .map{ $0.value }
            .compactMap{ $0 as? Validatable }
    }

    var allRequiredMembers: [Mandatory & Validatable]
    {
        return Mirror(reflecting: self)
            .children
            .map{ $0.value }
            .compactMap{ $0 as? Mandatory & Validatable }
    }
}
