//
//  Main.swift
//  MKHValueWrapperTst
//
//  Created by Maxim Khatskevich on 8/22/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCTest

//@testable
import XCEValidatableValue

//===

class MKHValueWrapperTst: XCTestCase
{
    func testSomeConstantValueWrapper()
    {
        let u = MyUser()
        
        XCTAssertTrue(u.someConstantValue.isValid())
        XCTAssertEqual(try! u.someConstantValue.value(), 3)
    }
    
    func testFirstNameValueWrapper()
    {
        var u = MyUser()
        
        //===
        
        XCTAssertFalse(u.firstName.isValid())
        
        //===
        
        do
        {
            try u.firstName.setValue("")
            XCTFail("Should not get here ever")
        }
        catch
        {
            XCTAssertTrue(error is InvalidValue)
        }
        
        //===
        
        XCTAssertFalse(u.firstName.isValid())
        
        //===
        
        do
        {
            try u.firstName.setValue("Max")
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //===
        
        XCTAssertEqual(try! u.firstName.value(), "Max")
        XCTAssertTrue(u.firstName.isValid())
        
        //===
        
        do
        {
            try u.firstName.setValue("Alex")
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //===
        
        XCTAssertEqual(try! u.firstName.value(), "Alex")
        XCTAssertTrue(u.firstName.isValid())
    }
}
