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

//---

class MKHValueWrapperTst: XCTestCase
{
    func testSomeConstantValueWrapper()
    {
        //swiftlint:disable:next identifier_name
        let u = MyUser()
        
        //---
        
        Assert("Constant value is valid").isTrue
        {
            u.someConstant.isValid
        }
        
        //---
        
        Assert("Const vlaue is equal to pre-defined value").isTrue
        {
            try u.someConstant.valueIfValid() == MyUser.someConstantValue
        }
    }
    
    func testFirstNameValueWrapper()
    {
        //swiftlint:disable:next identifier_name
        var u = MyUser()
        
        //---
        
        Assert("Initially 'firstName' is NOT valid").isTrue
        {
            !u.firstName.isValid
        }
        
        //---
        
        let emptyString = ""
        
        //---
        
        do
        {
            try u.firstName.set(emptyString)
            
            XCTFail("Should not get here ever")
        }
        catch
        {
            Assert("An empty string is NOT a valid value for 'firstName'").isTrue
            {
                if
                    case ValidatableValueError.conditionCheckFailed(_, _) = error
                {
                    return true
                }
                else
                {
                    return false
                }
            }
        }
        
        //---
        
        Assert("'firstName' is untapped, so it's still NOT valid").isTrue
        {
            !u.firstName.isValid
        }
        
        //---
        
        let firstName = "Max"
        let anotherFirstName = "Alex"
        
        //---
        
        do
        {
            try u.firstName << firstName
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //---
        
        Assert("'firstName' is now set to '\(firstName)'").isTrue
        {
            u.firstName.draft == firstName
        }
        
        Assert("'firstName' is now VALID").isTrue
        {
            u.firstName.isValid
        }
        
        //---
        
        do
        {
            try u.firstName.set(anotherFirstName)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //---
        
        Assert("'firstName' is now set to '\(anotherFirstName)'").isTrue
        {
            u.firstName.draft == anotherFirstName
        }
        
        Assert("'firstName' is now VALID").isTrue
        {
            u.firstName.isValid
        }
    }
    
    func testLastNameValueWrapper()
    {
        //swiftlint:disable:next identifier_name
        var u = MyUser()
        
        //---
        
        Assert("'lastName' is empty").isNil
        {
            u.lastName.draft
        }
        
        //---
        
        Assert("'lastName' is VALID even if it's empty").isTrue
        {
            u.lastName.isValid
        }
        
        //---
        
        u.lastName <? nil
        
        Assert("'nil' is VALID for 'lastName'").isTrue
        {
            u.lastName.isValid
        }
        
        u.lastName <? ""
        
        Assert("Empty string is VALID for 'lastName'").isTrue
        {
            u.lastName.isValid
        }
        
        u.lastName.draft = "ldfewihfiqeuwbfweiubf"
        
        Assert("A random non-empty string is VALID for 'lastName'").isTrue
        {
            u.lastName.isValid
        }
    }
}
