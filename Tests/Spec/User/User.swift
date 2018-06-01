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

import XCEValidatableValue

//---

struct MyUser//: ValidatableEntity
{
    static
    let someConstantValue = 3
    
    let someConstant = MandatoryValue(initialValue: MyUser.someConstantValue)

    var firstName = String.nonEmpty

    var lastName = OptionalValue<String>()
        // no requirements on value, even "nil" is okay

    var username = String.nonEmpty
        .check("Valid email address", String.isValidEmail)

    var password = MandatoryValue<String>(
        Check("Lenght between 8 and 30 characters"){ 8...30 ~= $0.count },
        Check("At least 1 capital character"){ 1 <= Pwd.caps.count(at: $0) },
        Check("At least 4 lower characters"){ 4 <= Pwd.lows.count(at: $0) },
        Check("At least 1 digit character"){ 1 <= Pwd.digits.count(at: $0) },
        Check("At least 1 special character"){ 1 <= Pwd.specials.count(at: $0) },
        Check("Valid characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) })
}

// MARK: - Helpers

fileprivate
extension MyUser
{
    /**

     To eliminate the need of 'draft' property being 'manually' declared in each type -
     declare only 'wrapper' or 'validator ctr' or 'core' which embed into final type as generic
     parameter??? Probably this core type should be mandatory/optional. So we declare
     only 'core' validator, which is essentially defines only base type and set of checks/conditions.

     */
    struct Email: MandatoryValidatable { typealias Value = String

        static
        let conditions = [

            String.nonEmptyCheck,
            Check("Valid email address", String.isValidEmail)
        ]

        var draft: Value?
    }

    struct FirstName: MandatoryValidatable { typealias Value = String

        static
        let validations = [

            Check<Value>("Non-empty") { !$0.isEmpty }
        ]

        var draft: Draft

        init() { }
    }

    struct Password: MandatoryValidatable { typealias Value = String

        static
        let validations = [

            Check("Lenght between 8 and 30 characters"){ 8...30 ~= $0.count },
            Check("At least 1 capital character"){ 1 <= Pwd.caps.count(at: $0) },
            Check("At least 4 lower characters"){ 4 <= Pwd.lows.count(at: $0) },
            Check("At least 1 digit character"){ 1 <= Pwd.digits.count(at: $0) },
            Check("At least 1 special character"){ 1 <= Pwd.specials.count(at: $0) },
            Check("Valid characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) }
        ]

        var draft: Draft

        init() { }
    }
}

fileprivate
extension String
{
    static
    let nonEmptyCheck = Check<String>("Non-empty"){ !$0.isEmpty }
}

