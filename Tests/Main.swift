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

import XCERequirement
import XCETesting

//===

class MKHValueWrapperTst: XCTestCase
{
    func testSomeConstantValueWrapper()
    {
        let u = MyUser()
        
        //===
        
        RXC.isTrue("Constant value is valid") {
            
            u.someConstant.isValid()
        }
        
        //===
        
        RXC.isTrue("Const vlaue is equal to pre-defined value") {
            
            u.someConstant.value == MyUser.someConstantValue
        }
    }
    
    func testFirstNameValueWrapper()
    {
        var u = MyUser()
        
        //===
        
        RXC.isTrue("Initially 'firstName' is NOT valid") {
            
            !u.firstName.isValid()
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
                
                error is RequirementNotFulfilled // RequirementIssue
            }
        }
        
        //===
        
        RXC.isTrue("'firstName' is untapped, so it's still NOT valid") {
            
            !u.firstName.isValid()
        }
        
        //===
        
        let firstName = "Max"
        let anotherFirstName = "Alex"
        
        //===
        
        do
        {
            try u.firstName.set(firstName)
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
            
            u.firstName.isValid()
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
            
            u.firstName.isValid()
        }
    }
}
