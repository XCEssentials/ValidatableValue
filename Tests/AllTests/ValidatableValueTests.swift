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
    func test_validType_inferred()
    {
        enum FirstName: SomeValidatableValue
        {
            typealias Raw = String
        }
        
        XCTAssert(FirstName.Raw.self == String.self)
        XCTAssert(FirstName.Valid.self == String.self) // inferred!
    }
    
    func test_validType_explicitDeclaration()
    {
        enum Age: SomeValidatableValue
        {
            typealias Raw = String
            typealias Valid = UInt
            
            static
            func convert(rawValue: String) -> UInt?
            {
                .init(rawValue)
            }
        }
        
        XCTAssert(Age.Raw.self == String.self)
        XCTAssert(Age.Valid.self == UInt.self) // inferred!
    }
    
    func test_isEmpty_implicit_collection()
    {
        enum FirstName: SomeValidatableValue
        {
            typealias Raw = String
        }
        
        XCTAssertTrue(FirstName.isEmpty(rawValue: ""))
        XCTAssertFalse(FirstName.isEmpty(rawValue: "1"))
    }
    
    func test_isEmpty_implicit_nonCollection()
    {
        enum Age: SomeValidatableValue
        {
            typealias Raw = Int
        }
        
        XCTAssertFalse(Age.isEmpty(rawValue: 0))
        XCTAssertFalse(Age.isEmpty(rawValue: 1))
    }
    
    func test_isEmpty_explicit_collection()
    {
        enum FirstName: SomeValidatableValue
        {
            typealias Raw = String
            
            static
            func isEmpty(rawValue: String) -> Bool
            {
                false
            }
        }
        
        XCTAssertFalse(FirstName.isEmpty(rawValue: ""))
        XCTAssertFalse(FirstName.isEmpty(rawValue: "1"))
    }
    
    func test_isEmpty_explicit_nonCollection()
    {
        enum Age: SomeValidatableValue
        {
            typealias Raw = Int
            
            static
            func isEmpty(rawValue: Int) -> Bool
            {
                true
            }
        }
        
        XCTAssertTrue(Age.isEmpty(rawValue: 0))
        XCTAssertTrue(Age.isEmpty(rawValue: 1))
    }
    
    func test_conditions_implicit()
    {
        enum FirstName: SomeValidatableValue
        {
            typealias Raw = String
        }

        XCTAssertEqual(FirstName.conditionsOnRaw.count, 0)
        XCTAssertEqual(FirstName.conditionsOnRaw.filter { $0.isValid("") }.count, 0)
        XCTAssertEqual(FirstName.conditionsOnRaw.filter { $0.isValid("asdasdq") }.count, 0) // 0!
    }
    
    func test_conditions_explicit()
    {
        enum FirstName: SomeValidatableValue
        {
            typealias Raw = String

            static
            let conditionsOnRaw = [

                String.checkNonEmpty
            ]
        }

        XCTAssertEqual(FirstName.conditionsOnRaw.count, 1)
        XCTAssertEqual(FirstName.conditionsOnRaw.filter { $0.isValid("") }.count, 0)
        XCTAssertEqual(FirstName.conditionsOnRaw.filter { $0.isValid("asdasdq") }.count, 1)
    }

    func test_convert_implicitForRawRepresentable()
    {
        enum ColorPreference: SomeValidatableValue
        {
            typealias Raw = String
            
            enum Valid: String, Codable
            {
                case white
                case black
            }
        }
        
        XCTAssert(ColorPreference.convert(rawValue: "white") == .white)
        XCTAssertNil(ColorPreference.convert(rawValue: "sdfsdf"))
    }
}
