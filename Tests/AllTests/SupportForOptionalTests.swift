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
        struct SomeObj: DisplayNamed {}

        let obj: SomeObj? = SomeObj()

        XCTAssert(type(of: obj).displayName == SomeObj.displayName)
    }

    func testIsRequired()
    {
        enum SomeSpec: SomeValueSpecification
        {
            typealias RawValue = Int
        }

        struct SomeWrapper: SomeValidatableValueWrapper, NonMandatory
        {
            typealias Specification = SomeSpec

            typealias Value = Specification.RawValue

            var value: Value

            init(wrappedValue: Value)
            {
                self.value = wrappedValue
            }
        }

        struct SomeMandatoryWrapper: SomeValidatableValueWrapper, Mandatory
        {
            typealias Specification = SomeSpec

            typealias Value = Specification.RawValue

            var value: Value

            init(wrappedValue: Value)
            {
                self.value = wrappedValue
            }
        }

        //---

        XCTAssertFalse(Optional<SomeWrapper>.isRequired)
        XCTAssertFalse(Optional.some(SomeWrapper(wrappedValue: 1)).isRequired)

        XCTAssert(Optional<SomeMandatoryWrapper>.isRequired)
        XCTAssert(Optional.some(SomeMandatoryWrapper(wrappedValue: 1)).isRequired)
    }

    func testBasicValueWrapper()
    {
        struct SomeWrapper: SomeValidatableValueWrapper
        {
            enum Specification: SomeValueSpecification
            {
                typealias RawValue = String
            }

            var value: Specification.RawValue

            init(wrappedValue: String) { self.value = wrappedValue }
        }

        //---

        let someValue = "sdkjiw"

        let wrapper = SomeWrapper(wrappedValue: someValue)
        let optionalWrapper: SomeWrapper? = SomeWrapper(wrappedValue: someValue)

        XCTAssert(type(of: wrapper).displayName == SomeWrapper.displayName)
        XCTAssert(type(of: optionalWrapper).displayName == SomeWrapper.displayName)

        XCTAssert(wrapper.value == optionalWrapper?.value)
    }

    func testValidatableWithOptionalWrapper()
    {
        enum FirstName: SomeValueSpecification
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct SomeWrapper: SomeValidatableValueWrapper,
            NonMandatory
        {
            typealias Specification = FirstName

            typealias Value = Specification.RawValue

            var value: Value

            init(wrappedValue: Value)
            {
                self.value = wrappedValue
            }
        }

        //---

        let validValue = "Sam"
        let emptyValue = ""

        //---

        do
        {
            try Optional.some(SomeWrapper(wrappedValue: validValue)).validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            try Optional.some(SomeWrapper(wrappedValue: emptyValue)).validate()

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
            try Optional<SomeWrapper>.none.validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testValidatableWithMandatoryWrapper()
    {
        enum FirstName: SomeValueSpecification
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct MandatoryWrapper: SomeValidatableValueWrapper,
            Mandatory // <<<<------
        {
            typealias Specification = FirstName

            typealias Value = Specification.RawValue

            var value: Value

            init(wrappedValue: Value)
            {
                self.value = wrappedValue
            }
        }

        //---

        let validValue = "Sam"
        let emptyValue = ""

        //---

        do
        {
            try Optional.some(MandatoryWrapper(wrappedValue: validValue)).validate()
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }

        //---

        do
        {
            try Optional.some(MandatoryWrapper(wrappedValue: emptyValue)).validate()

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
            try Optional<MandatoryWrapper>.none.validate()

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
        enum FirstName: SomeValueSpecification
        {
            typealias Value = String

            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct WrapperWithSpec: SomeValidatableValueWrapper,
            NonMandatory
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

    func testOptionalValueWrapper()
    {
        enum FirstName: SomeValueSpecification
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct SomeWrapper: SomeValidatableValueWrapper,
            NonMandatory
        {
            typealias Specification = FirstName

            typealias Value = Specification.RawValue

            var value: Value

            init(wrappedValue: Value)
            {
                self.value = wrappedValue
            }
        }

        //---

        let validValue = "Sam"
        let emptyValue = ""

        //--- valid

        do
        {
            let result = try SomeWrapper?
                .some(validValue.wrapped())?
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

            let result = try SomeWrapper?
                .some(validValue.wrapped())?
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
            _ = try SomeWrapper?
                .some(emptyValue.wrapped())?
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

            let result = try SomeWrapper?
                .some(emptyValue.wrapped())?
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
            let result = try SomeWrapper?
                .none?
                .validValue()

            if
                let _ = result
            {
                XCTFail("Should not get here ever")
            }
            else
            {
                XCTAssert(result == nil)
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

            let result = try SomeWrapper?
                .none?
                .validValue(&issues)

            XCTAssert(issues.count == 0)

            if
                let _ = result
            {
                XCTFail("Should not get here ever")
            }
            else
            {
                XCTAssert(result == nil)
            }
        }
        catch
        {
            print(error)
            XCTFail("Should not get here ever")
        }
    }

    func testMandatoryValueWrapper()
    {
        enum FirstName: SomeValueSpecification
        {
            static
            let conditions = [

                String.checkNonEmpty
            ]
        }

        struct MandatoryWrapper: SomeValidatableValueWrapper,
            Mandatory // <<<---
        {
            typealias Specification = FirstName

            typealias Value = Specification.RawValue

            var value: Value

            init(wrappedValue: Value)
            {
                self.value = wrappedValue
            }
        }

        //---

        let validValue = "Sam"
        let emptyValue = ""

        //--- valid

        do
        {
            let result = try MandatoryWrapper?
                .some(validValue.wrapped())
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

            let result = try MandatoryWrapper?
                .some(validValue.wrapped())
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
            _ = try MandatoryWrapper?
                .some(emptyValue.wrapped())
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

            let result = try MandatoryWrapper?
                .some(emptyValue.wrapped())
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
            _ = try MandatoryWrapper?
                .none
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

            let result = try MandatoryWrapper?
                .none
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
