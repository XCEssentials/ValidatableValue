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
            AutoDisplayNamed,
            AutoValidatable
        {
            static
            let customReport = ("This is", "it!")

            //---

            static
            var reportReview: EntityReportReview
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
            AutoDisplayNamed,
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
        struct SimpleWrapper: ValueWrapper,
            AutoDisplayNamed,
            Validatable
        {
            typealias Value = String?

            var value: Value

            init(_ value: Value) { self.value = value }

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
                .init(stringWrapper: SimpleWrapper(nil))
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
                .init(stringWrapper: SimpleWrapper("Some valid value"))
                .validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }
}
