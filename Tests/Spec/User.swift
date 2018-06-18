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

import XCEValidatableValue

// MARK: - User

struct User: ValidatableEntity,
    AutoDisplayNamed,
    AutoReporting
{
    static
    var someConstantValue: Int { return 3 }

    //---

    let someConstant = someConstantValue.wrapped()

    var firstName = FirstName.wrapped()

    var lastName = LastName?.wrapped()

    var username = Username.wrapped() // rely on implicit 'displayName'!

    var password = Password.wrapped() // rely on implicit 'displayName'!
}

// MARK: - User: Representations

extension User
{
//    typealias Draft = (
//        someConstant: Int?,
//        firstName: String?,
//        lastName: String?,
//        username: String?,
//        passwordIsSet: Bool
//    )
//
//    func draft() -> Draft
//    {
//        return (
//            someConstant.value,
//            firstName.value,
//            lastName.value,
//            username.value,
//            password.value != nil
//        )
//    }

    //---

    typealias Valid =
    (
        someConstant: Int,
        firstName: String,
        lastName: String?,
        username: String
    )

    func valid() throws -> Valid
    {
        var issues: [ValidationError] = []

        let someConstant = try self.someConstant.validValue(&issues)
        let firstName = try self.firstName.validValue(&issues)
        let lastName = self.lastName.value
        let username = try self.username.validValue(&issues)
        // NOTE: we are skipping Password!

        //---

        if
            issues.isEmpty
        {
            return (
                someConstant!,
                firstName!,
                lastName,
                username!
            )
        }
        else
        {
            throw issues.asValidationIssues(for: self)
        }
    }
}

// MARK: - User: Validators & Name Providers

extension User
{
    static
    let someNewSpecReportMessage = "This is a static message for all errors"

    enum SomeNewSpec: ValueSpecification,
        AutoDisplayNamed
    {
        static
        let conditions = [

            String.checkNonEmpty
        ]

        static
        let reportReview: ValueReportReview = {

            $1.title = "Title"
            $1.message = someNewSpecReportMessage
        }
    }

    enum FirstName: ValueSpecification,
        AutoDisplayNamed,
        AutoReporting
    {
        static
        let conditions = [

            String.checkNonEmpty
        ]
    }

    enum LastName: ValueSpecification,
        AutoDisplayNamed,
        NoConditions
    {
        typealias Value = String
    }

    enum Username: ValueSpecification,
        AutoDisplayNamed,
        AutoReporting
    {
        static
        let conditions = [

            String.checkNonEmpty,
            Check("Valid email address", String.isValidEmail)
        ]
    }

    enum Password: ValueSpecification,
        AutoDisplayNamed,
        AutoReporting
    {
        static
        let conditions: Conditions<String> = [

            Check("Lenght between 8 and 30 characters")
            { 8...30 ~= $0.count },
            Check("Has at least 1 capital character")
            { 1 <= Pwd.caps.count(at: $0) },
            Check("Has at least 4 lower characters")
            { 4 <= Pwd.lows.count(at: $0) },
            Check("Has at least 1 digit character")
            { 1 <= Pwd.digits.count(at: $0) },
            Check("Has at least 1 special character")
            { 1 <= Pwd.specials.count(at: $0) },
            Check("""
                    Consists of lowercase letters, decimal digits and
                    following characters: ,.!?@#$%^&*()-_+=
                    """)
            { Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) }
        ]
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

fileprivate
extension String
{
    static
    let checkNonEmpty = Check<String>("Non-empty"){ !$0.isEmpty }

    //---

    static
    func isValidEmail(_ value: String) -> Bool
    {
        let emailRegex =
            "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)

        return emailTest.evaluate(with: value)
    }
}

// MARK: - CharacterSet helpers

fileprivate
typealias CS = CharacterSet // swiftlint:disable:this type_name

fileprivate
extension CS
{
    func count(at str: String) -> UInt
    {
        var result: UInt = 0

        //---

        //swiftlint:disable:next identifier_name
        for c in str
            where String(c).rangeOfCharacter(from: self) != nil
        {
            result += 1
        }

        //---

        return result
    }
}
