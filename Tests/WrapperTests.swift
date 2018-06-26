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

    func testSingleValueCodable()
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
}
