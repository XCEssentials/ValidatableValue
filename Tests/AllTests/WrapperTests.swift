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

import XCERequirement

@testable
import XCEValidatableValue

//---

class WrapperTests: XCTestCase {}

// MAKR: - Nested types

extension WrapperTests
{
    enum EmptyStringOk: SomeValidatableValue
    {
        typealias Raw = String
    }
    
    enum NonEmptyString: SomeValidatableValue
    {
        static
        var conditions: [Check<String>] = [
        
            .init("Contains `a`", { $0.contains("a") })
        ]
    }
}

// MAKR: - Tests

extension WrapperTests
{
    func test_validValue_Required_EmptyStringOk_NonOptional()
    {
        var wrapper: Required<EmptyStringOk>
        
        //---
        
        wrapper = "".wrapped()
        
        XCTAssertEqual(try wrapper.validValue, "")
        
        //---
        
        wrapper = "aaa".wrapped()
        
        XCTAssertEqual(try wrapper.validValue, "aaa")
        
        //---
        
        XCTAssert(type(of: try wrapper.validValue) == String.self)
    }
    
    func test_validValue_Required_EmptyStringOk_Optional()
    {
        var wrapperMaybe: Required<EmptyStringOk>?
        
        //---
        
        wrapperMaybe = nil
        
        XCTAssertThrowsError(try wrapperMaybe.validValue) {
            
            guard
                case ValidationError.requiredValueIsMissing = $0
            else
            {
                return XCTFail("Unexpected error: \($0)")
            }
        }
        
        //---
        
        wrapperMaybe = "".wrapped()

        XCTAssertEqual(try wrapperMaybe.validValue, "")

        //---

        wrapperMaybe = "aaa".wrapped()

        XCTAssertEqual(try wrapperMaybe.validValue, "aaa")
        
        //---
        
        XCTAssert(type(of: try wrapperMaybe.validValue) == String.self)
    }
    
    func test_validValue_NonRequired_EmptyStringOk_NonOptional()
    {
        var wrapper: NonRequired<EmptyStringOk>
        
        //---
        
        wrapper = "".wrapped()
        
        XCTAssertEqual(try wrapper.validValue, "")
        
        //---
        
        wrapper = "aaa".wrapped()
        
        XCTAssertEqual(try wrapper.validValue, "aaa")
        
        //---
        
        XCTAssert(type(of: try wrapper.validValue) == String.self)
    }
    
    func test_validValue_NonRequired_EmptyStringOk_Optional()
    {
        var wrapperMaybe: NonRequired<EmptyStringOk>?
        
        /// NOTE: if we try to access `validValue` directly on `wrapperMaybe`
        /// (wihtout unwrapping it) we will get following compilation error:
        ///
        /// "Property `validValue` requires that `NonRequired<EmptyStringOk>`
        /// conform to `Mandatory`"
        ///
        /// This is intentional design choice, if you have non-required
        /// value wrapper - access it through the optional unwrapping,
        /// case valid value is supposed to optional by definition,
        /// `NonRequired` is designed to be always used insdie `Optional`,
        /// cause if you set a value - then it will behave just like
        /// `Required` and validate the value according to the `conditions`,
        /// EXCEPT the way it handles empty collections.
        
        //---
        
        wrapperMaybe = nil

        XCTAssertNil(try wrapperMaybe?.validValue) // NOTE: does NOT throw!

        //---

        wrapperMaybe = "".wrapped()

        XCTAssertEqual(try wrapperMaybe?.validValue, .some(""))

        //---

        wrapperMaybe = "aaa".wrapped()

        XCTAssertEqual(try wrapperMaybe?.validValue, .some("aaa"))
        
        //---
        
        XCTAssert(type(of: try wrapperMaybe?.validValue) == String?.self)
    }
    
    func test_validValue_Required_NonEmptyString_NonOptional()
    {
        var wrapper: Required<NonEmptyString>
        
        //---
        
        wrapper = "".wrapped()
        
        XCTAssertThrowsError(try wrapper.validValue) {
            
            guard
                case ValidationError.unsatisfiedConditions = $0
            else
            {
                return XCTFail("Unexpected error: \($0)")
            }
        }
        
        //---
        
        wrapper = "aaa".wrapped()
        
        XCTAssertEqual(try wrapper.validValue, "aaa")
        
        //---
        
        XCTAssert(type(of: try wrapper.validValue) == String.self)
    }
    
    func test_validValue_Required_NonEmptyString_Optional()
    {
        var wrapperMaybe: Required<NonEmptyString>?
        
        //---
        
        wrapperMaybe = nil
        
        XCTAssertThrowsError(try wrapperMaybe.validValue) {
            
            guard
                case ValidationError.requiredValueIsMissing = $0
            else
            {
                return XCTFail("Unexpected error: \($0)")
            }
        }
        
        //---
        
        wrapperMaybe = "".wrapped()
        
        XCTAssertThrowsError(try wrapperMaybe.validValue) {
            
            guard
                case ValidationError.unsatisfiedConditions = $0
            else
            {
                return XCTFail("Unexpected error: \($0)")
            }
        }
        
        //---
        
        wrapperMaybe = "aaa".wrapped()
        
        XCTAssertEqual(try wrapperMaybe.validValue, "aaa")
        
        //---
        
        XCTAssert(type(of: try wrapperMaybe.validValue) == String.self)
    }
    
    func test_validValue_NonRequired_NonEmptyString_NonOptional()
    {
        var wrapper: NonRequired<NonEmptyString>
        
        //---
        
        wrapper = "".wrapped()
        
        XCTAssertThrowsError(try wrapper.validValue) {
            
            guard
                case ValidationError.unsatisfiedConditions = $0
            else
            {
                return XCTFail("Unexpected error: \($0)")
            }
        }
        
        //---
        
        wrapper = "aaa".wrapped()
        
        XCTAssertEqual(try wrapper.validValue, "aaa")
        
        //---
        
        XCTAssert(type(of: try wrapper.validValue) == String.self)
    }
    
    func test_validValue_NonRequired_NonEmptyString_Optional()
    {
        var wrapperMaybe: NonRequired<NonEmptyString>?
        
        /// NOTE: if we try to access `validValue` directly on `wrapperMaybe`
        /// (wihtout unwrapping it) we will get following compilation error:
        ///
        /// "Property `validValue` requires that `NonRequired<EmptyStringOk>`
        /// conform to `Mandatory`"
        ///
        /// This is intentional design choice, if you have non-required
        /// value wrapper - access it through the optional unwrapping,
        /// case valid value is supposed to optional by definition,
        /// `NonRequired` is designed to be always used insdie `Optional`,
        /// cause if you set a value - then it will behave just like
        /// `Required` and validate the value according to the `conditions`,
        /// EXCEPT the way it handles empty collections.
        
        //---
        
        wrapperMaybe = nil

        XCTAssertNil(try wrapperMaybe?.validValue) // NOTE: does NOT throw!

        //---

        wrapperMaybe = "".wrapped()

        XCTAssertThrowsError(try wrapperMaybe?.validValue) {
            
            guard
                case ValidationError.unsatisfiedConditions = $0
            else
            {
                return XCTFail("Unexpected error: \($0)")
            }
        }

        //---

        wrapperMaybe = "aaa".wrapped()

        XCTAssertEqual(try wrapperMaybe?.validValue, .some("aaa"))
        
        //---
        
        XCTAssert(type(of: try wrapperMaybe?.validValue) == String?.self)
    }
    
    func testDisplayName()
    {
        enum LastName: SomeValidatableValue
        {
            typealias Raw = String
            
            static
            let displayName = "Your Last Name"
            
            static
            let displayPlaceholder: String? = "Your last/family name here"
            
            static
            let displayHint: String? = "We need to know your last name"
        }

        let wrapper: Required<LastName> = "Smith".wrapped()

        XCTAssertEqual(wrapper.displayName, "Your Last Name")
        XCTAssertEqual(wrapper.displayPlaceholder, "Your last/family name here")
        XCTAssertEqual(wrapper.displayHint, "We need to know your last name")
    }

    func testSingleValueCodable()
    {
        enum LastName: SomeValidatableValue
        {
            typealias Raw = String
        }
        
        let wrapper: Required<LastName> = "Smith".wrapped()

        do
        {
            let encodedWrapper = try JSONEncoder().encode(wrapper)
            let encodedWrapperStr = String(data: encodedWrapper, encoding: .utf8)
            
            XCTAssertEqual(encodedWrapperStr!, "\"Smith\"")
        }
        catch
        {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
