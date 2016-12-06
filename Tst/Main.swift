//
//  Main.swift
//  MKHValueWrapperTst
//
//  Created by Maxim Khatskevich on 8/22/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCTest

//@testable
import MKHValidatableValue

//===

class MKHValueWrapperTst: XCTestCase
{
    struct MyUser
    {
        let someConstantValue = ValidatableValue(const: 3)
        var firstName = ValidatableValue<String>{ $0.characters.count > 0 }
    }
    
    //===
    
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
            try u.firstName.setValue(5)
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
            let tmp: String? = nil
            try u.firstName.setValue(tmp)
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
            XCTFail("Should not get here ever")
        }
        catch
        {
            XCTAssertTrue(error is MutabilityViolation)
        }
        
        //===
        
        XCTAssertEqual(try! u.firstName.value(), "Max")
        XCTAssertTrue(u.firstName.isValid())
    }
}
