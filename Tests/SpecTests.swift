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

class SpecTests: XCTestCase {}

//---

extension SpecTests
{
    func testSkipBuiltInValidation()
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

    func testSpecialConditions()
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

    func testDefaultValueReport()
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

    func testCustomValueReport()
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

    func testDisplayName()
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
}
