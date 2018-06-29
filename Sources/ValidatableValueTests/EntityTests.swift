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

class EntityTests: XCTestCase {}

//---

extension EntityTests
{
    func testConditionalConformance()
    {
        enum FirstName: BasicValueSpecification
        {
            typealias Value = String
        }

        struct SomeWrapper: ValueWrapper,
            AutoValidatable,
            AutoReporting
        {
            typealias Specification = FirstName

            typealias Value = Specification.Value

            var value: Value

            init(wrappedValue: Value)
            {
                self.value = wrappedValue
            }
        }

        //---

        let array: [Any] = [

            "Sam",
            SomeWrapper(wrappedValue: "John"),
            Optional<SomeWrapper>(wrappedValue: "David") as Any
        ]

        let valElements = array.compactMap{ $0 as? Validatable }

        print("Number of val members found: ---->>>>> \(valElements.count)")
        XCTAssert(valElements.count == 2) // only works in Swift 4.2+
    }

    func testAllValidatableMembers()
    {
        enum FirstName: BasicValueSpecification
        {
            typealias Value = String
        }

        struct TheEntity: BasicEntity
        {
            var wrap1: WrapperOf<FirstName>
            var wrap1Opt: WrapperOf<FirstName>?
            var wrap2: WrapperOfMandatory<FirstName>
            var wrap2Opt: WrapperOfMandatory<FirstName>?
        }

        let entity = TheEntity(
            wrap1: .init(wrappedValue: ""),
            wrap1Opt: .init(wrappedValue: ""),
            wrap2: .init(wrappedValue: ""),
            wrap2Opt: .init(wrappedValue: "")
        )

        //---

        let allMembers = Mirror(reflecting: entity).children

        allMembers.forEach
        {
            print("\n")

            print($0.label!)
            print(type(of: $0.value))
            print($0.value is Validatable)
        }

        let valMembers = entity.allValidatableMembers

        print("Number of val members found: ---->>>>> \(valMembers.count)")
        XCTAssert(valMembers.count == allMembers.count)
    }

    func testDisplayName()
    {
        struct SomeEntity: BasicEntity {}

        XCTAssert(SomeEntity.displayName == "Some Entity")

        //---

        struct CustomNamedEntity: ValidatableEntity,
            AutoValidatable,
            AutoReporting
        {
            static
            let customDisplayName = "This is a custom named Entity"

            static
            let displayName = customDisplayName
        }

        XCTAssert(CustomNamedEntity.displayName != "Custom Named Entity")
        XCTAssert(CustomNamedEntity.displayName == CustomNamedEntity.customDisplayName)
    }

    func testDefaultValueReport()
    {
        struct SomeEntity: BasicEntity {}

        let defaultReport = SomeEntity.defaultReport(with: [])

        let report = SomeEntity.prepareReport(with: [])

        XCTAssert(report == defaultReport)
    }

    func testCustomValueReport()
    {
        struct CustomReportEntity: ValidatableEntity,
            AutoValidatable
        {
            static
            let customReport = ("This is", "it!")

            //---

            static
            var reviewReport: EntityReportReview
            {
                // by default, we don't adjust anything in the report
                return {

                    _, report in

                    //---

                    report = customReport
                }
            }
        }

        let defaultReport = CustomReportEntity.defaultReport(with: [])

        let report = CustomReportEntity.prepareReport(with: [])

        XCTAssert(report != defaultReport)
        XCTAssert(report == CustomReportEntity.customReport)
    }

    func testManualValidation()
    {
        struct ManualValidationEntity: ValidatableEntity,
            AutoReporting
        {
            func validate() throws
            {
                let issues: [ValidationError] = [
                    .valueIsNotValid(
                        origin: "Some wrapper",
                        value: "Some value",
                        failedConditions: ["Test condition"],
                        report: (title: "Some test value", message: "Is invalid")
                    )
                ]

                throw issues.asValidationIssues(for: self)
            }
        }

        //---

        do
        {
            try ManualValidationEntity().validate()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.entityIsNotValid(let origin, let issues, _)
        {
            XCTAssert(origin == ManualValidationEntity.displayName)
            XCTAssert(issues.count == 1) // exactly as we've sent

            let report = issues[0].report

            XCTAssert(report.title == "Some test value")
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testAutoValidatable()
    {
        struct SimpleWrapper: BasicValueWrapper,
            Validatable
        {
            static
            let displayName: String = "Test Wrapper"

            typealias Value = String?

            var value: Value

            init(wrappedValue: Value) { self.value = wrappedValue }

            func validate() throws
            {
                if
                    value == nil
                {
                    throw ValidationError.mandatoryValueIsNotSet(
                        origin: type(of: self).displayName,
                        report: (
                            title: "Mandatory value is missing",
                            message: "Can't be nil"
                        )
                    )
                }
            }
        }

        struct AutoValidationEntity: BasicEntity
        {
            let stringWrapper: SimpleWrapper
        }

        //---

        do
        {
            try AutoValidationEntity
                .init(stringWrapper: SimpleWrapper(wrappedValue: nil))
                .validate()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.entityIsNotValid(let origin, let issues, _)
        {
            XCTAssert(origin == AutoValidationEntity.displayName)
            XCTAssert(issues.count == 1)

            let report = issues[0].report

            XCTAssert(report.message == "Can't be nil")
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            try AutoValidationEntity
                .init(stringWrapper: SimpleWrapper(wrappedValue: "Some valid value"))
                .validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }
}
