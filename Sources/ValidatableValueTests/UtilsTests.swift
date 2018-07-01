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

enum TypeOne {}

fileprivate
struct TypeTwo {}

//---

class UtilsTests: XCTestCase
{
    class TypeThree {}
}

//---

extension UtilsTests
{
    func testIntrinsicDisplayName()
    {
        enum TypeFour {}

        //---

        XCTAssert(Utils.intrinsicDisplayName(for: TypeOne.self) == "Type One")
        XCTAssert(Utils.intrinsicDisplayName(for: TypeTwo.self) == "Type Two")
        XCTAssert(Utils.intrinsicDisplayName(for: TypeThree.self) == "Type Three")
        XCTAssert(Utils.intrinsicDisplayName(for: TypeFour.self) == "Type Four")
    }
}
