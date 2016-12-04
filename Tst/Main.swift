//
//  Main.swift
//  MKHValueWrapperTst
//
//  Created by Maxim Khatskevich on 8/22/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCTest

//@testable
import MKHValueWrapper

//===

class MKHValueWrapperTst: XCTestCase
{
    struct MyUser
    {
        let someConstantValue = ValueWrapper(constant: 3)
        
        let firstName = ValueWrapper<String>{ $0.characters.count > 0 }
    }
    
    //===
    
    func testSomeConstantValueWrapper()
    {
        let u = MyUser()
        
        XCTAssertTrue(u.someConstantValue.isValid())
        XCTAssertEqual(u.someConstantValue.value!, 3)
    }
    
    func testFirstNameValueWrapper()
    {
        let u = MyUser()
        
        //===
        
        XCTAssertTrue(u.firstName.value == nil)
        XCTAssertFalse(u.firstName.isValid())
        
        //===
        
        do
        {
            try u.firstName.setValue(5)
            XCTFail("Should not get here ever")
        }
        catch
        {
            XCTAssertTrue(type(of: error) == InvalidValue.self)
        }
        
        //===
        
        XCTAssertTrue(u.firstName.value == nil)
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
            XCTAssertTrue(type(of: error) == InvalidValue.self)
        }
        
        //===
        
        XCTAssertTrue(u.firstName.value == nil)
        XCTAssertFalse(u.firstName.isValid())
        
        //===
        
        do
        {
            try u.firstName.setValue("")
            XCTFail("Should not get here ever")
        }
        catch
        {
            XCTAssertTrue(type(of: error) == InvalidValue.self)
        }
        
        //===
        
        XCTAssertTrue(u.firstName.value == nil)
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
        
        XCTAssertEqual(u.firstName.value!, "Max")
        XCTAssertTrue(u.firstName.isValid())
        
        //===
        
        do
        {
            try u.firstName.setValue("Alex")
            XCTFail("Should not get here ever")
        }
        catch
        {
            XCTAssertTrue(type(of: error) == MutabilityViolation.self)
        }
        
        //===
        
        XCTAssertEqual(u.firstName.value!, "Max")
        XCTAssertTrue(u.firstName.isValid())
    }
}
