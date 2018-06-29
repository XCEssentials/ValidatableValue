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

import XCTest

//@testable
import XCEValidatableValue

//---

class MainTests: XCTestCase
{
    var user = User()
}

// MARK: - Overrides

extension MainTests
{
    override
    func setUp()
    {
        super.setUp()

        //---

        user = User()
    }
}

// MARK: - Tests

extension MainTests
{
    func testDecoding()
    {
        struct SomeEntity: Codable
        {
            let name: String?
            let age: Int?
        }

        let encodedUser = """
            {
                "age": 4
            }
            """

        let encodedUserData = encodedUser.data(using: .utf8)!

        //---

        do
        {
            let decodedEntity = try JSONDecoder()
                .decode(
                    SomeEntity.self,
                    from: encodedUserData
            )

            XCTAssert(decodedEntity.name == nil)
        }
        catch
        {
            print("")
            print("ERROR: ==>>> \(error)")
            print("")
            XCTFail("Should not get here ever")
        }
    }

    func testUserDecodingWithMissingOptionalBasicKey()
    {
        // NOTE: we are missing the few
        // keys in the JSON below!

        let encodedUser = """
            {
                "username": "John@google.com",
                "password": "sdfewq234r2f2!"
            }
            """
        let encodedUserData = encodedUser.data(using: .utf8)!

        //---

        do
        {
            let decodedUser = try JSONDecoder()
                .decode(
                    User.self,
                    from: encodedUserData
            )

            // 'firstName' is a required field,
            // so when it's missing - it's invalid
            XCTAssertFalse(decodedUser.firstName.isValid)

            // 'lastName' is a NON-required field,
            // so when it's missing - it's okay
            XCTAssert(decodedUser.lastName.isValid)

            // ovrall user us not supposed to be valid
            XCTAssertFalse(decodedUser.isValid)
        }
        catch
        {
            print("")
            print("ERROR: ==>>> \(error)")
            print("")

            XCTFail("Should not get here ever")
        }
    }

    func testMissingValues()
    {
        //--- MANDATORY value

        do
        {
            _ = try user.firstName.validValue()
        }
        catch ValidationError.mandatoryValueIsNotSet(
            let origin,
            _
            )
        {
            XCTAssert(origin == user.firstName.displayName)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //--- NON-mandatory value

        do
        {
            _ = try user.experience.validValue()
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
    }

    func testMultipleErrors()
    {
        do
        {
            try user.validate()
        }
        catch ValidationError.entityIsNotValid(
            _,
            let issues, _
            )
        {
            XCTAssert(issues.count == user.allRequiredMembers.count)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
    }

    func testEntityValidation()
    {
        do
        {
            try user.validate()

            XCTFail("Should not get here ever")
        }
        catch let error as ValidationError
        {
            let report = error.report

            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"First Name\" is empty, but expected to be non-empty.\n- \"Username\" is empty, but expected to be non-empty.\n- \"Password\" is empty, but expected to be non-empty."

            XCTAssert(report.message == expectedReportMessage)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        user.firstName <? "Jonh"

        //---

        do
        {
            try user.validate()

            XCTFail("Should not get here ever")
        }
        catch let error as ValidationError
        {
            let report = error.report

            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Username\" is empty, but expected to be non-empty.\n- \"Password\" is empty, but expected to be non-empty."

            XCTAssert(report.message == expectedReportMessage)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        user.username <? "Jonh@.yaaa"

        //---

        do
        {
            try user.validate()

            XCTFail("Should not get here ever")
        }
        catch let error as ValidationError
        {
            let report = error.report

            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Username\" is invalid, because it does not satisfy following conditions: [\"Valid email address\"].\n- \"Password\" is empty, but expected to be non-empty."

            XCTAssert(report.message == expectedReportMessage)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        user.username <? "Jonh@google.co"

        //---

        do
        {
            try user.validate()

            XCTFail("Should not get here ever")
        }
        catch let error as ValidationError
        {
            let report = error.report

            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Password\" is empty, but expected to be non-empty."

            XCTAssert(report.message == expectedReportMessage)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        user.password <? "123t5y7gh"

        //---

        do
        {
            try user.validate()

            XCTFail("Should not get here ever")
        }
        catch let error as ValidationError
        {
            let report = error.report

            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Password\" is invalid, because it does not satisfy following conditions: [\"Has at least 1 capital character\", \"Has at least 1 special character\"]."

            XCTAssert(report.message == expectedReportMessage)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        // now lets improve the password to satisfy ALL conditions

        user.password <? "!C3t5y7gh"

        //---

        do
        {
            try user.validate()

            // now user is valid...
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
    }

    func testConstVV()
    {
        user.username <? "john@google.com" // correctEmail

        do
        {
            try user.username.validate()

            XCTAssert(user.username.isValid)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        user.username <? "john@google" // incorrectEmail

        do
        {
            XCTAssertFalse(user.username.isValid)

            XCTAssert(Optional<NonRequired<User.Username>>(wrappedValue: nil).isValid)

            try user.username.validate()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid
        {
            // this is expected
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
    }

    func testWholeUserIsValid()
    {
        user.firstName <? "Max"
        user.lastName <? "Kevi"
        user.username <? "maxim@google.com"
        // forgot password...

        XCTAssertFalse(user.isValid)

        user.password <? "123t5y7gh"

        XCTAssertFalse(user.isValid)
        XCTAssertFalse(user.password.isValid)

        // now lets improve the password to satisfy ALL password conditions

        user.password <? "!C3t5y7gh"

        XCTAssert(user.isValid)
    }

    func testFirstNameValueWrapper()
    {
        XCTAssertFalse(user.firstName.isValid)

        //---

        let emptyString = ""

        //---

        do
        {
            try user.firstName.set(emptyString)

            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid
        {
            // An empty string is NOT a valid value for 'firstName'
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        XCTAssertFalse(user.firstName.isValid)

        //---

        let firstName = "Max"
        let anotherFirstName = "Alex"

        //---

        do
        {
            try user.firstName << firstName
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        XCTAssert(user.firstName.value == firstName)
        XCTAssert(user.firstName.isValid)

        //---

        do
        {
            try user.firstName.set(anotherFirstName)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }

        //---

        XCTAssert(user.firstName.value == anotherFirstName)
        XCTAssert(user.firstName.isValid)
    }
}
