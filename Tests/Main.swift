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

@testable
import XCEValidatableValue

import XCETesting

//---

class MainTests: XCTestCase
{
//    var user = User()
}

// MARK: - Overrides

//extension MainTests
//{
//    override
//    func setUp()
//    {
//        super.setUp()
//
//        //---
//
//        user = User()
//    }
//}

// MARK: - Tests

extension MainTests
{
    func testSpecSkipBuiltInValidation()
    {
        enum LastName: ValueSpecification
        {
            typealias Value = String
        }

        XCTAssert(LastName.performBuiltInValidation)

        //---

        enum LastName2: ValueSpecification,
            SkipBuiltInValidation
        {
            typealias Value = String
        }

        XCTAssert(!LastName2.performBuiltInValidation)
    }

    func testSpecSpecialConditions()
    {
        enum FirstName: ValueSpecification,
            SpecialConditions
        {
            typealias Value = String

            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        XCTAssert(FirstName.conditions.count == 1)
        XCTAssert(try FirstName.collectFailedConditions("").count == 1)
        XCTAssert(try FirstName.collectFailedConditions("asdasdq").count == 0)

        //---

        enum LastName: ValueSpecification
        {
            typealias Value = String
        }

        // XCTAssert(LastName.conditions.count == 0) // should NOT even compile!
        XCTAssert(try LastName.collectFailedConditions("").count == 0) // 0!
        XCTAssert(try LastName.collectFailedConditions("asdasdq").count == 0)
    }

    func testSpecDefaultValueReport()
    {
        enum FirstName: ValueSpecification
        {
            typealias Value = String
        }

        let defaultReport = FirstName.defaultValidationReport(with: [])

        let report = FirstName.prepareReport(
            value: nil,
            failedConditions: [],
            builtInValidationIssues: [],
            suggestedReport: defaultReport
        )

        XCTAssert(report == defaultReport)
    }

    func testSpecCustomValueReport()
    {
        enum LastName: ValueSpecification,
            CustomValueReport
        {
            static
            let customReport = ("This is", "it!")

            //---

            typealias Value = String

            static
            var reportReview: ValueReportReview
            {
                // by default, we don't adjust anything in the report
                return {

                    _, report in

                    //---

                    report = customReport
                }
            }
        }

        let defaultReport = LastName.defaultValidationReport(with: [])

        let report = LastName.prepareReport(
            value: nil,
            failedConditions: [],
            builtInValidationIssues: [],
            suggestedReport: defaultReport
        )

        XCTAssert(report != defaultReport)
        XCTAssert(report == LastName.customReport)
    }

    func testSpecDisplayName()
    {
        enum FirstName: ValueSpecification
        {
            typealias Value = String
        }

        XCTAssert(FirstName.displayName == "First Name")

        //---

        enum LastName: ValueSpecification,
            CustomDisplayNamed
        {
            typealias Value = String

            static
            let customDisplayName = "This is custom name for the Value"
        }

        XCTAssert(LastName.displayName != "Last Name")
        XCTAssert(LastName.displayName == LastName.customDisplayName)
    }

    func testWrapperDisplayName()
    {
        struct BasicWrapper: ValueWrapper
        {
            typealias Value = String

            var value: String

            init(_ value: String) { self.value = value }
        }

        XCTAssert(BasicWrapper.displayName == "Basic Wrapper")

        //---

        struct CustomNamedWrapper: ValueWrapper,
            CustomDisplayNamed
        {
            typealias Value = String

            var value: String

            init(_ value: String) { self.value = value }

            static
            let customDisplayName = "This is a custom named wrapper"
        }

        XCTAssert(CustomNamedWrapper.displayName != "Custom Named Wrapper")
        XCTAssert(CustomNamedWrapper.displayName == CustomNamedWrapper.customDisplayName)

        //---

        enum LastName: ValueSpecification
        {
            typealias Value = String
        }

        struct WrapperWithSpec: ValueWrapper,
            WithSpecification
        {
            typealias Specification = LastName

            typealias Value = Specification.Value

            var value: Value

            init(_ value: Value) { self.value = value }
        }

        XCTAssert(WrapperWithSpec.displayName != "Wrapper With Spec")
        XCTAssert(WrapperWithSpec.displayName == LastName.displayName)

        //---

        struct CustomNamedWrapperWithSpec: ValueWrapper,
            WithSpecification,
            CustomDisplayNamed
        {
            typealias Specification = LastName

            typealias Value = Specification.Value

            var value: Value

            init(_ value: Value) { self.value = value }

            static
            let customDisplayName = "This is a custom named wrapper"
        }

        XCTAssert(CustomNamedWrapperWithSpec.displayName != "Custom Named Wrapper")
        XCTAssert(CustomNamedWrapperWithSpec.displayName != LastName.displayName)
        XCTAssert(CustomNamedWrapperWithSpec.displayName == CustomNamedWrapperWithSpec.customDisplayName)
    }

    func testWrapperSingleValueCodable()
    {
        struct ImplicitlyCodableWrapper: ValueWrapper
        {
            typealias Value = String

            var value: String

            init(_ value: String) { self.value = value }
        }

        //---

        do
        {
            let wrapper = ImplicitlyCodableWrapper("Test")

            let encodedWrapper = try JSONEncoder().encode(wrapper)

            let encodedWrapperStr = String(data: encodedWrapper, encoding: .utf8)

            XCTAssert(encodedWrapperStr! == "{\"value\":\"Test\"}")
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        struct ExplicitlyCodableWrapper: ValueWrapper,
            SingleValueCodable
        {
            typealias Value = String

            var value: String

            init(_ value: String) { self.value = value }
        }

        struct Entity: Codable
        {
            let wrapper: ExplicitlyCodableWrapper
        }

        //---

        do
        {
            let testValue = "SingleValueCodable"

            let entity = Entity(
                wrapper: ExplicitlyCodableWrapper(testValue)
            )

            let encodedEntity = try JSONEncoder().encode(entity)

            let encodedEntityStr = String(data: encodedEntity, encoding: .utf8)

            XCTAssert(encodedEntityStr! == "{\"wrapper\":\"\(testValue)\"}")

            //---

            let decodedEntity = try JSONDecoder().decode(Entity.self, from: encodedEntity)

            XCTAssert(decodedEntity.wrapper.value == testValue)
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testEntityDisplayName()
    {
        struct BasicEntity: ValidatableEntity {}

        XCTAssert(BasicEntity.displayName == "Basic Entity")

        //---

        struct CustomNamedEntity: ValidatableEntity,
            CustomDisplayNamed
        {
            static
            let customDisplayName = "This is a custom named Entity"
        }

        XCTAssert(CustomNamedEntity.displayName != "Custom Named Entity")
        XCTAssert(CustomNamedEntity.displayName == CustomNamedEntity.customDisplayName)
    }

//    func testDecoding()
//    {
//        struct SomeEntity: Codable
//        {
//            let name: String?
//            let age: Int?
//        }
//
//        let encodedUser = """
//            {
//                "age": 4
//            }
//            """
//
//        let encodedUserData = encodedUser.data(using: .utf8)!
//
//        //---
//
//        do
//        {
//            let decodedEntity = try JSONDecoder()
//                .decode(
//                    SomeEntity.self,
//                    from: encodedUserData
//            )
//
//            XCTAssert(decodedEntity.name == nil)
//        }
//        catch
//        {
//            print("")
//            print("ERROR: ==>>> \(error)")
//            print("")
//            XCTFail("Should not get here ever")
//        }
//    }

//    func testUserDecodingWithMissingOptionalBasicKey()
//    {
//        // NOTE: we are missing the 'phoneNumber' key in the JSON below!
//
//        let encodedUser = """
//            {
//                "someConstant": "4",
//                "firstName": "John",
//                "lastName": "Doe",
//                "username": "John@google.com",
//                "password": "sdfewq234r2f2!"
//            }
//            """
//        let encodedUserData = encodedUser.data(using: .utf8)!
//
//        //---
//
//        do
//        {
//            let decodedUser = try JSONDecoder()
//                .decode(
//                    User.self,
//                    from: encodedUserData
//            )
//
//            XCTAssert(decodedUser.isValid == false)
//        }
//        catch
//        {
//            print("")
//            print("ERROR: ==>>> \(error)")
//            print("")
//
//            XCTFail("Should not get here ever")
//        }
//    }

//    func testDifferentUnwrapValue()
//    {
//        do
//        {
//            _ = try Int.wrapped().validValue()
//        }
//        catch let error as ValidationError
//        {
//            print(error.report.message)
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        do
//        {
//            _ = try User.SomeNewSpec.wrapped().validValue()
//        }
//        catch let error as ValidationError
//        {
//            XCTAssert(error.report.message == User.someNewSpecReportMessage)
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//    }
//
//
//    func testIntrinsicName()
//    {
//        XCTAssert(User.SomeNewSpec.displayName == "Some New Spec")
//    }
//
//    func testMultipleErrors()
//    {
//        do
//        {
//            try user.validate()
//        }
//        catch ValidationError.entityIsNotValid(_, let issues, _)
//        {
//            XCTAssert(issues.count == 3)
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//    }
//
//    func testEntityValidation()
//    {
//        Assert("User is NOT valid in the beginning").isFalse
//        {
//            user.isValid
//        }
//
//        //---
//
//        do
//        {
//            try user.validate()
//
//            XCTFail("Should not get here ever")
//        }
//        catch let error as ValidationError
//        {
//            let report = error.report
//
//            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"First Name\" is empty, but expected to be non-empty.\n- \"Username\" is empty, but expected to be non-empty.\n- \"Password\" is empty, but expected to be non-empty."
//
//            Assert("Report is equal to expected one").isTrue{
//
//                report.message == expectedReportMessage
//            }
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        user.firstName <? "Jonh"
//
//        //---
//
//        do
//        {
//            try user.validate()
//
//            XCTFail("Should not get here ever")
//        }
//        catch let error as ValidationError
//        {
//            let report = error.report
//
//            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Username\" is empty, but expected to be non-empty.\n- \"Password\" is empty, but expected to be non-empty."
//
//            Assert("Report is equal to expected one").isTrue{
//
//                report.message == expectedReportMessage
//            }
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        user.username <? "Jonh@.yaaa"
//
//        //---
//
//        do
//        {
//            try user.validate()
//
//            XCTFail("Should not get here ever")
//        }
//        catch let error as ValidationError
//        {
//            let report = error.report
//
//            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Username\" is invalid, because it does not satisfy following conditions: [\"Valid email address\"].\n- \"Password\" is empty, but expected to be non-empty."
//
//            Assert("Report is equal to expected one").isTrue{
//
//                report.message == expectedReportMessage
//            }
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        user.username <? "Jonh@google.co"
//
//        //---
//
//        do
//        {
//            try user.validate()
//
//            XCTFail("Should not get here ever")
//        }
//        catch let error as ValidationError
//        {
//            let report = error.report
//
//            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Password\" is empty, but expected to be non-empty."
//
//            Assert("Report is equal to expected one").isTrue{
//
//                report.message == expectedReportMessage
//            }
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        user.password <? "123t5y7gh"
//
//        //---
//
//        do
//        {
//            try user.validate()
//
//            XCTFail("Should not get here ever")
//        }
//        catch let error as ValidationError
//        {
//            let report = error.report
//
//            let expectedReportMessage = "\"User\" validation failed due to the issues listed below.\n- \"Password\" is invalid, because it does not satisfy following conditions: [\"Has at least 1 capital character\", \"Has at least 1 special character\"]."
//
//            Assert("Report is equal to expected one").isTrue{
//
//                report.message == expectedReportMessage
//            }
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        // now lets improve the password to satisfy ALL conditions
//
//        user.password <? "!C3t5y7gh"
//
//        //---
//
//        do
//        {
//            try user.validate()
//
//            // now user is valid...
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//    }
//
//    func testConstVV()
//    {
//        Assert("Const number value is valid").isNotNil
//        {
//            try? 42.wrappedConst()
//        }
//
//        //---
//
//        let correctEmail = "john@google.com"
//
//        Assert("Correct const email value is valid").isNotNil
//        {
//            try? User.Username.wrapped(const: correctEmail)
//        }
//
//        //---
//
//        let incorrectEmail = "john@google"
//
//        Assert("Incorrect const email value is NOT valid").isNil
//        {
//            try? User.Username.wrapped(const: incorrectEmail)
//        }
//
//        //---
//
//        Assert("Correct const email value is valid").isTrue
//        {
//            User.Username?.wrapped(initialValue: correctEmail).isValid
//        }
//
//        //---
//
//        Assert("Incorrect const email value is NOT valid").isFalse
//        {
//            User.Username.wrapped(initialValue: incorrectEmail).isValid
//        }
//
//        //---
//
//        Assert("EMPTY optional email value is valid").isTrue
//        {
//            User.Username?.wrapped().isValid
//        }
//
//        //---
//
//        do
//        {
//            _ = try User.Username.wrapped(const: incorrectEmail)
//
//            XCTFail("Should not get here ever")
//        }
//        catch
//        {
//            print(error)
//        }
//    }
//
//    func testWholeUserIsValid()
//    {
//        user.firstName <? "Max"
//        user.lastName <? "Kevi"
//        user.username <? "maxim@google.com"
//        // forgot password...
//
//        Assert("Whole entity is NOT valid yet").isFalse
//        {
//            user.isValid
//        }
//
//        user.password <? "123t5y7gh"
//
//        Assert("Whole entity is NOT valid yet").isFalse
//        {
//            user.isValid
//        }
//
//        // because...
//
//        Assert("Password value is NOT valid yet").isFalse
//        {
//            user.password.isValid
//        }
//
//        do
//        {
//            try user.validate()
//        }
//        catch
//        {
//            print(error) // see in  console for detailed explanation what's failed!
//        }
//
//        // now lets improve the password to satisfy ALL conditions
//
//        user.password <? "!C3t5y7gh"
//
//        Assert("Whole entity is valid").isTrue
//        {
//            user.isValid
//        }
//    }
//
//    func testSomeConstantValueWrapper()
//    {
//        Assert("Constant value is valid").isTrue
//        {
//            user.someConstant.isValid
//        }
//
//        //---
//
//        Assert("Const vlaue is equal to pre-defined value").isTrue
//        {
//            try user.someConstant.validValue() == User.someConstantValue
//        }
//    }
//
//    func testFirstNameValueWrapper()
//    {
//        Assert("Initially 'firstName' is NOT valid").isTrue
//        {
//            !user.firstName.isValid
//        }
//
//        //---
//
//        let emptyString = ""
//
//        //---
//
//        do
//        {
//            try user.firstName.set(emptyString)
//
//            XCTFail("Should not get here ever")
//        }
//        catch _ as ValidationError
//        {
//            // "An empty string is NOT a valid value for 'firstName'"
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        Assert("'firstName' is untapped, so it's still NOT valid").isTrue
//        {
//            !user.firstName.isValid
//        }
//
//        //---
//
//        let firstName = "Max"
//        let anotherFirstName = "Alex"
//
//        //---
//
//        do
//        {
//            try user.firstName << firstName
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        Assert("'firstName' is now set to '\(firstName)'").isTrue
//        {
//            user.firstName.value == firstName
//        }
//
//        Assert("'firstName' is now VALID").isTrue
//        {
//            user.firstName.isValid
//        }
//
//        //---
//
//        do
//        {
//            try user.firstName.set(anotherFirstName)
//        }
//        catch
//        {
//            XCTFail("Should not get here ever")
//        }
//
//        //---
//
//        Assert("'firstName' is now set to '\(anotherFirstName)'").isTrue
//        {
//            user.firstName.value == anotherFirstName
//        }
//
//        Assert("'firstName' is now VALID").isTrue
//        {
//            user.firstName.isValid
//        }
//    }
}
