//
//  UtilsTests.swift
//  ValidatableValueTests
//
//  Created by Maxim Khatskevich on 2018-06-29.
//

import XCTest

@testable
import XCEValidatableValue

//---

enum TypeOne: DisplayNamed {}

fileprivate
struct TypeTwo: DisplayNamed {}

//---

class UtilsTests: XCTestCase
{
    class TypeThree: DisplayNamed {}
}

//---

extension UtilsTests
{
    func testIntrinsicDisplayName()
    {
        enum TypeFour: DisplayNamed {}

        //---

        XCTAssert(TypeOne.intrinsicDisplayName == "Type One")
        XCTAssert(TypeTwo.intrinsicDisplayName == "Type Two")
        XCTAssert(TypeThree.intrinsicDisplayName == "Type Three")
        XCTAssert(TypeFour.intrinsicDisplayName == "Type Four")
    }
}
