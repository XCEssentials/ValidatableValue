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

//---

class WrapperTests: XCTestCase {}

//---

extension WrapperTests
{
    func testDisplayName()
    {
        enum LastName: ValueSpecification
        {
            typealias Value = String
        }

        struct WrapperWithSpec: ValueWrapper
        {
            typealias Specification = LastName

            typealias Value = Specification.Value

            var value: Value

            init(wrappedValue: Value) { self.value = wrappedValue }
        }

        XCTAssert(WrapperWithSpec.displayName != WrapperWithSpec.intrinsicDisplayName)
        XCTAssert(WrapperWithSpec.displayName == LastName.displayName)

        //---

        struct AnotherWrapper: ValueWrapper
        {
            typealias Specification = LastName

            typealias Value = Specification.Value

            var value: Value

            init(wrappedValue: Value) { self.value = wrappedValue }

            static
            let someStr = "This is a custom named wrapper"

            static
            let displayName = someStr
        }

         XCTAssert(AnotherWrapper.displayName == AnotherWrapper.someStr)
    }

    func testSingleValueCodable()
    {
        struct ImplicitlyCodableWrapper: BasicValueWrapper
        {
            typealias Value = String

            var value: String

            init(wrappedValue: String) { self.value = wrappedValue }
        }

        //---

        do
        {
            let wrapper = ImplicitlyCodableWrapper(wrappedValue: "Test")

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

        struct ExplicitlyCodableWrapper: BasicValueWrapper,
            SingleValueCodable
        {
            typealias Value = String

            var value: String

            init(wrappedValue: String) { self.value = wrappedValue }
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
                wrapper: ExplicitlyCodableWrapper(wrappedValue: testValue)
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

    func testMandatoryWithSpec()
    {
        enum LastName: ValueSpecification,
            NonMandatory
        {
            typealias Value = String

            static
            let customReport = ("Custom report", "about Last Name")

            static
            let reviewReport: ValueReportReview =
            {
                _, report in

                //---

                report = customReport
            }
        }

        struct WrapperWithSpec: ValueWrapper,
            Mandatory
        {
            typealias Specification = LastName
            typealias Value = LastName.Value

            var value: Value

            init(wrappedValue: Value) { self.value = wrappedValue }
        }

        let defaultReport = WrapperWithSpec.defaultEmptyValueReport

        let report = WrapperWithSpec.Specification.prepareReport(
            value: nil,
            failedConditions: [],
            builtInValidationIssues: [],
            suggestedReport: defaultReport
        )

        XCTAssert(report != defaultReport)
        XCTAssert(report == LastName.customReport)
    }

    func testConvenienceHelpersAndAutoValidatable()
    {
        enum LastName: ValueSpecification
        {
            typealias Value = String

            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct WrapperWithSpec: ValueWrapper
        {
            typealias Specification = LastName

            typealias Value = Specification.Value

            var value: Value

            init(wrappedValue: Value) { self.value = wrappedValue }
        }

        //---

        let validValue = "John"

        do
        {
            try WrapperWithSpec.validate(value: validValue)

            var wrapper = try WrapperWithSpec(validate: validValue)

            try wrapper.set(validValue)
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        let invalidValue = ""

        do
        {
            try WrapperWithSpec.validate(value: invalidValue)
            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid(
            let origin,
            let value,
            let failedConditions,
            let report
            )
        {
            XCTAssert(origin == WrapperWithSpec.displayName)
            XCTAssert(value is String)
            XCTAssert((value as! String) == invalidValue)
            XCTAssert(failedConditions.count == 1)
            XCTAssert(failedConditions[0] == LastName.conditions[0].description)
            XCTAssert(report == LastName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            _ = try WrapperWithSpec(validate: invalidValue)
            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid(
            let origin,
            let value,
            let failedConditions,
            let report
            )
        {
            XCTAssert(origin == WrapperWithSpec.displayName)
            XCTAssert(value is String)
            XCTAssert((value as! String) == invalidValue)
            XCTAssert(failedConditions.count == 1)
            XCTAssert(failedConditions[0] == LastName.conditions[0].description)
            XCTAssert(report == LastName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            var wrapper = try! WrapperWithSpec(validate: validValue)

            try wrapper.set(invalidValue)

            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid(
            let origin,
            let value,
            let failedConditions,
            let report
            )
        {
            XCTAssert(origin == WrapperWithSpec.displayName)
            XCTAssert(value is String)
            XCTAssert((value as! String) == invalidValue)
            XCTAssert(failedConditions.count == 1)
            XCTAssert(failedConditions[0] == LastName.conditions[0].description)
            XCTAssert(report == LastName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }
}
