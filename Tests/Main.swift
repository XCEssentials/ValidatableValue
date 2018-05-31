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

import XCETesting

//===

class MKHValueWrapperTst: XCTestCase
{
    func testSomeConstantValueWrapper()
    {
        //swiftlint:disable:next identifier_name
        let u = MyUser()
        
        //===
        
        RXC.isTrue("Constant value is valid") {
            
            u.someConstant.isValid
        }
        
        //===
        
        RXC.isTrue("Const vlaue is equal to pre-defined value") {
            
            u.someConstant.value == MyUser.someConstantValue
        }
    }
    
    func testFirstNameValueWrapper()
    {
        //swiftlint:disable:next identifier_name
        var u = MyUser()
        
        //===
        
        RXC.isTrue("Initially 'firstName' is NOT valid") {
            
            !u.firstName.isValid
        }
        
        //===
        
        let emptyString = ""
        
        //===
        
        do
        {
            try u.firstName.set(emptyString)
            
            XCTFail("Should not get here ever")
        }
        catch
        {
            RXC.isTrue("An empty string is NOT a valid value for 'firstName'") {
                
                error is ValidationFailed
            }
        }
        
        //===
        
        RXC.isTrue("'firstName' is untapped, so it's still NOT valid") {
            
            !u.firstName.isValid
        }
        
        //===
        
        let firstName = "Max"
        let anotherFirstName = "Alex"
        
        //===
        
        do
        {
            try u.firstName << firstName
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //===
        
        RXC.isTrue("'firstName' is now set to '\(firstName)'") {
            
            u.firstName.value == firstName
        }
        
        RXC.isTrue("'firstName' is now VALID") {
            
            u.firstName.isValid
        }
        
        //===
        
        do
        {
            try u.firstName.set(anotherFirstName)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //===
        
        RXC.isTrue("'firstName' is now set to '\(anotherFirstName)'") {
            
            u.firstName.value == anotherFirstName
        }
        
        RXC.isTrue("'firstName' is now VALID") {
        
            u.firstName.isValid
        }
    }
    
    func testLastNameValueWrapper()
    {
        //swiftlint:disable:next identifier_name
        var u = MyUser()
        
        //===
        
        RXC.isNil("'lastName' is empty") {

            u.lastName.value
        }
        
        //===
        
        RXC.isTrue("'lastName' is VALID even if it's empty") {
            
            u.lastName.isValid
        }
        
        //===
        
        u.lastName <? nil
        
        RXC.isTrue("'nil' is VALID for 'lastName'") {
            
            u.lastName.isValid
        }
        
        u.lastName <? ""
        
        RXC.isTrue("Empty string is VALID for 'lastName'") {
            
            u.lastName.isValid
        }
        
        u.lastName.draft = "ldfewihfiqeuwbfweiubf"
        
        RXC.isTrue("A random non-empty string is VALID for 'lastName'") {
            
            u.lastName.isValid
        }
    }
}
