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

class SupportForOptionalTests: XCTestCase {}

//---

extension SupportForOptionalTests
{
    func testDisplayName()
    {
        struct SomeObj: DisplayNamed
        {
            static
            let displayName = "This is the name"
        }

        let obj: SomeObj? = SomeObj()

        XCTAssert(type(of: obj).displayName == SomeObj.displayName)
    }

    func testBasicValueWrapper()
    {
        struct SomeWrapper: ValueWrapper,
            AutoDisplayNamed
        {
            typealias Value = String

            var value: Value

            init(wrappedValue: String) { self.value = wrappedValue }
        }

        //---

        let someValue = "sdkjiw"

        let wrapper = SomeWrapper(wrappedValue: someValue)
        let optionalWrapper: SomeWrapper? = SomeWrapper(wrappedValue: someValue)

        XCTAssert(type(of: wrapper).displayName == SomeWrapper.displayName)
        XCTAssert(type(of: optionalWrapper).displayName == type(of: wrapper).displayName)

        XCTAssert(wrapper.value == optionalWrapper.value)
    }

    func testValidatableWithOptionalWrapper()
    {
        enum FirstName: ValueSpecification,
            AutoDisplayNamed,
            AutoReporting
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct SomeWrapper: ValueWrapper,
            AutoDisplayNamed,
            WithSpecification,
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

        let validValue = "Sam"
        let emptyValue = ""
        let noValue: String? = nil

        //---

        do
        {
            try Optional<SomeWrapper>(wrappedValue: validValue).validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            try Optional<SomeWrapper>(wrappedValue: emptyValue).validate()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid(
            let origin,
            let value,
            let failedConditions,
            let report
            )
        {
            XCTAssert(origin == SomeWrapper.displayName)
            XCTAssert(value is String)
            XCTAssert((value as! String ) == emptyValue)
            XCTAssert(failedConditions == [String.checkNonEmpty.description])
            XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            try Optional<SomeWrapper>(wrappedValue: noValue).validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testValidatableWithMandatoryWrapper()
    {
        enum FirstName: ValueSpecification,
            AutoDisplayNamed,
            AutoReporting
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct MandatoryWrapper: ValueWrapper,
            AutoDisplayNamed,
            WithSpecification,
            AutoValidatable,
            AutoReporting,
            Mandatory // <<<<------
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

        let validValue = "Sam"
        let emptyValue = ""
        let noValue: String? = nil

        //---

        do
        {
            try Optional<MandatoryWrapper>(wrappedValue: validValue).validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            try Optional<MandatoryWrapper>(wrappedValue: emptyValue).validate()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid(
            let origin,
            let value,
            let failedConditions,
            let report
            )
        {
            XCTAssert(origin == MandatoryWrapper.displayName)
            XCTAssert(value is String)
            XCTAssert((value as! String ) == emptyValue)
            XCTAssert(failedConditions == [String.checkNonEmpty.description])
            XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            try Optional<MandatoryWrapper>(wrappedValue: noValue).validate()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.mandatoryValueIsNotSet(
            let origin,
            let report
            )
        {
            XCTAssert(origin == MandatoryWrapper.displayName)
            XCTAssert(report == MandatoryWrapper.defaultEmptyValueReport)
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testValidatableConvenienceHelpers()
    {
        enum FirstName: ValueSpecification,
            AutoDisplayNamed,
            AutoReporting
        {
            typealias Value = String

            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct WrapperWithSpec: ValueWrapper,
            AutoDisplayNamed,
            WithSpecification,
            AutoValidatable
        {
            typealias Specification = FirstName

            typealias Value = Specification.Value

            var value: Value

            init(wrappedValue: Value) { self.value = wrappedValue }
        }

        //---

        let validValue = "John"

        do
        {
            try Optional<WrapperWithSpec>.validate(value: validValue)

            var optionalWrapper = try Optional<WrapperWithSpec>(validate: validValue)

            try optionalWrapper.set(validValue)
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
            try Optional<WrapperWithSpec>.validate(value: invalidValue)

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
            XCTAssert(failedConditions[0] == FirstName.conditions[0].description)
            XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            _ = try Optional<WrapperWithSpec>(validate: invalidValue)

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
            XCTAssert(failedConditions[0] == FirstName.conditions[0].description)
            XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            var optionalWrapper = try! Optional<WrapperWithSpec>(validate: validValue)

            try optionalWrapper.set(invalidValue)

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
            XCTAssert(failedConditions[0] == FirstName.conditions[0].description)
            XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testOptionalValidatableValueWrapper()
    {
        enum FirstName: ValueSpecification,
            AutoDisplayNamed,
            AutoReporting
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct SomeWrapper: ValidatableValueWrapper,
            AutoDisplayNamed,
            WithSpecification,
            AutoValidatable,
            AutoReporting,
            AutoValidValue
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

        let validValue = "Sam"
        let emptyValue = ""
        let noValue: String? = nil

        //--- valid

        do
        {
            let result = try Optional<SomeWrapper>(wrappedValue: validValue)
                .validValue()

            if
                let unwrapped = result
            {
                XCTAssert(unwrapped == validValue)
            }
            else
            {
                XCTFail("Should not get here ever")
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        do
        {
            var issues: [ValidationError] = []

            let result = try Optional<SomeWrapper>(wrappedValue: validValue)
                .validValue(&issues)

            XCTAssert(issues.count == 0)

            if
                let unwrapped = result
            {
                XCTAssert(unwrapped == validValue)
            }
            else
            {
                XCTFail("Should not get here ever")
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //--- empty

        do
        {
            _ = try Optional<SomeWrapper>(wrappedValue: emptyValue)
                .validValue()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid(
            let origin,
            let value,
            let failedConditions,
            let report
            )
        {
            XCTAssert(origin == SomeWrapper.displayName)
            XCTAssert(value is String)
            XCTAssert((value as! String) == emptyValue)
            XCTAssert(failedConditions == [String.checkNonEmpty.description])
            XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        do
        {
            var issues: [ValidationError] = []

            let result = try Optional<SomeWrapper>(wrappedValue: emptyValue)
                .validValue(&issues)

            if
                let unwrapped = result,
                case ValidationError.valueIsNotValid(
                    let origin,
                    let value,
                    let failedConditions,
                    let report
                ) = issues[0]
            {
                XCTAssert(unwrapped == emptyValue)

                XCTAssert(origin == SomeWrapper.displayName)
                XCTAssert(value is String)
                XCTAssert((value as! String) == emptyValue)
                XCTAssert(failedConditions == [String.checkNonEmpty.description])
                XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
            }
            else
            {
                XCTFail("Should not get here ever")
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //--- NO

        do
        {
            let result = try Optional<SomeWrapper>(wrappedValue: noValue)
                .validValue()

            if
                let _ = result
            {
                XCTFail("Should not get here ever")
            }
            else
            {
                XCTAssert(result == noValue)
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        do
        {
            var issues: [ValidationError] = []

            let result = try Optional<SomeWrapper>(wrappedValue: noValue)
                .validValue(&issues)

            XCTAssert(issues.count == 0)

            if
                let _ = result
            {
                XCTFail("Should not get here ever")
            }
            else
            {
                XCTAssert(result == noValue)
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testMandatoryValidatableValueWrapper()
    {
        enum FirstName: ValueSpecification,
            AutoDisplayNamed,
            AutoReporting
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct MandatoryWrapper: ValidatableValueWrapper,
            AutoDisplayNamed,
            WithSpecification,
            AutoValidatable,
            AutoReporting,
            AutoValidValue,
            Mandatory // <<<---
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

        let validValue = "Sam"
        let emptyValue = ""
        let noValue: String? = nil

        //--- valid

        do
        {
            let result = try Optional<MandatoryWrapper>(wrappedValue: validValue)
                .validValue()

            XCTAssert(result == validValue)
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        do
        {
            var issues: [ValidationError] = []

            let result = try Optional<MandatoryWrapper>(wrappedValue: validValue)
                .validValue(&issues)

            XCTAssert(issues.count == 0)

            if
                let unwrapped = result
            {
                XCTAssert(unwrapped == validValue)
            }
            else
            {
                XCTFail("Should not get here ever")
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //--- empty

        do
        {
            _ = try Optional<MandatoryWrapper>(wrappedValue: emptyValue)
                .validValue()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.valueIsNotValid(
            let origin,
            let value,
            let failedConditions,
            let report
            )
        {
            XCTAssert(origin == MandatoryWrapper.displayName)
            XCTAssert(value is String)
            XCTAssert((value as! String) == emptyValue)
            XCTAssert(failedConditions == [String.checkNonEmpty.description])
            XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        do
        {
            var issues: [ValidationError] = []

            let result = try Optional<MandatoryWrapper>(wrappedValue: emptyValue)
                .validValue(&issues)

            if
                let _ = result
            {
                XCTFail("Should not get here ever")
            }
            else
            if
                case ValidationError.valueIsNotValid(
                    let origin,
                    let value,
                    let failedConditions,
                    let report
                ) = issues[0]
            {
                XCTAssert(origin == MandatoryWrapper.displayName)
                XCTAssert(value is String)
                XCTAssert((value as! String) == emptyValue)
                XCTAssert(failedConditions == [String.checkNonEmpty.description])
                XCTAssert(report == FirstName.defaultValidationReport(with: failedConditions))
            }
            else
            {
                XCTFail("Should not get here ever")
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //--- NO

        do
        {
            _ = try Optional<MandatoryWrapper>(wrappedValue: noValue)
                .validValue()

            XCTFail("Should not get here ever")
        }
        catch ValidationError.mandatoryValueIsNotSet(
            let origin,
            let report
            )
        {
            XCTAssert(origin == MandatoryWrapper.displayName)
            XCTAssert(report == MandatoryWrapper.defaultEmptyValueReport)
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        do
        {
            var issues: [ValidationError] = []

            let result = try Optional<MandatoryWrapper>(wrappedValue: noValue)
                .validValue(&issues)

            XCTAssert(issues.count == 1)

            if
                let _ = result
            {
                XCTFail("Should not get here ever")
            }
            else
            if
                case ValidationError.mandatoryValueIsNotSet(
                    let origin,
                    let report
                ) = issues[0]
            {
                XCTAssert(origin == MandatoryWrapper.displayName)
                XCTAssert(report == MandatoryWrapper.defaultEmptyValueReport)
            }
            else
            {
                XCTFail("Should not get here ever")
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }
}
