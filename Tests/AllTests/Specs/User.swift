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
import XCERequirement

// only publically available members!
import XCEValidatableValue

// MARK: - User

struct User: SomeValidatableEntity
{
    var firstName: Required<FirstName>?
    var lastName: NonRequired<LastName>?
    var username: Required<Username>?
    var password: Required<Password>?
    var experience: NonRequired<Experience>?
    var isVIP: NonRequired<VIP>?
}

// MARK: - User: Value Specs

fileprivate
typealias CS = CharacterSet

extension User
{
    enum FirstName: SomeValidatableValue
    {
        static
        let conditionsOnRaw = [

            String.checkNonEmpty
        ]
    }

    enum LastName: SomeValidatableValue
    {
        typealias Raw = String
    }

    enum Username: SomeValidatableValue
    {
        static
        let conditionsOnRaw = [

            String.checkNonEmpty,
            Requirement("Valid email address", String.isValidEmail)
        ]
    }

    enum Password: SomeValidatableValue, IsSecretValue
    {
        static
        let conditionsOnRaw: [Condition<String>] = [

            Requirement("Lenght between 8 and 30 characters"){ 8...30 ~= $0.count },
            Requirement("Has at least 1 capital character"){ 1 <= Pwd.caps.count(in: $0) },
            Requirement("Has at least 4 lower characters"){ 4 <= Pwd.lows.count(in: $0) },
            Requirement("Has at least 1 digit character"){ 1 <= Pwd.digits.count(in: $0) },
            Requirement("Has at least 1 special character"){ 1 <= Pwd.specials.count(in: $0) },
            Requirement("Allowed characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) }
        ]
    }

    enum Experience: SomeValidatableValue //yrs
    {
        typealias Raw = UInt
    }

    enum VIP: SomeCheckmarkValidatableValue {}
}

// MARK: - User: Representations

extension User
{
    typealias DraftShortOverview = (
        firstName: String?,
        lastName: String?,
        username: String?,
        passwordIsSet: Bool
    )

    func draftShortOverview() -> DraftShortOverview
    {
        return (
            firstName?.rawValue,
            lastName?.rawValue,
            username?.rawValue,
            password?.rawValue != nil
        )
    }

    //---

    typealias ValidShortOverview =
    (
        firstName: String,
        lastName: String?,
        username: String,
        passwordIsValid: Bool
    )

    func validShortOverview() throws -> ValidShortOverview
    {
        return try (
            firstName.validValue,
            lastName?.validValue,
            username.validValue,
            password.isValid
        )
    }
}

// MARK: - Password helpers

fileprivate
enum Pwd
{
    static
    let caps = CS.uppercaseLetters

    static
    let lows = CS.lowercaseLetters

    static
    let digits = CS.decimalDigits

    static
    let specials = CS(charactersIn: " ,.!?@#$%^&*()-_+=")

    static
    var allowed = caps.union(lows).union(digits).union(specials)
}

// MARK: - String helpers
