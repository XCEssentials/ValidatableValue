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

//@testable
import XCEValidatableValue

import XCETesting

//---

class MainTests: XCTestCase
{
    var user = MyUser()
}

// MARK: - Overrides

extension MainTests
{
    override
    func setUp()
    {
        user = MyUser()
    }
}

// MARK: - Tests

extension MainTests
{
    func testWholeUserIsValid()
    {
//        user.firstName <? "Max"
//        user.lastName <? "Kevi"
//        user.username <? "maxim@google.com"
//        // forgot password...
//
//        Assert("Whole entity is NOT valid yet").isFalse
//        {
//            user.isValid
//        }
//
//        user.password <? "!C3t5y7gh"
//
//        do
//        {
//            try user.validate()
//        }
//        catch
//        {
//            print("ERROR ===>>> \(error)")
//        }
//
//        Assert("Whole entity is valid").isTrue
//        {
//            user.isValid
//        }
    }

    func testSomeConstantValueWrapper()
    {
        Assert("Constant value is valid").isTrue
        {
            user.someConstant.isValid
        }
        
        //---
        
        Assert("Const vlaue is equal to pre-defined value").isTrue
        {
            try user.someConstant.valueIfValid() == MyUser.someConstantValue
        }
    }
    
    func testFirstNameValueWrapper()
    {
        Assert("Initially 'firstName' is NOT valid").isTrue
        {
            !user.firstName.isValid
        }
        
        //---
        
        let emptyString = ""
        
        //---
        
        do
        {
            try user.firstName.set(emptyString)
            
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
            !user.firstName.isValid
        }
        
        //---
        
        let firstName = "Max"
        let anotherFirstName = "Alex"
        
        //---
        
        do
        {
            try user.firstName << firstName
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //---
        
        Assert("'firstName' is now set to '\(firstName)'").isTrue
        {
            user.firstName.draft == firstName
        }
        
        Assert("'firstName' is now VALID").isTrue
        {
            user.firstName.isValid
        }
        
        //---
        
        do
        {
            try user.firstName.set(anotherFirstName)
        }
        catch
        {
            XCTFail("Should not get here ever")
        }
        
        //---
        
        Assert("'firstName' is now set to '\(anotherFirstName)'").isTrue
        {
            user.firstName.draft == anotherFirstName
        }
        
        Assert("'firstName' is now VALID").isTrue
        {
            user.firstName.isValid
        }
    }
    
    func testLastNameValueWrapper()
    {
        Assert("'lastName' is empty").isNil
        {
            user.lastName.draft
        }
        
        //---
        
        Assert("'lastName' is VALID even if it's empty").isTrue
        {
            user.lastName.isValid
        }
        
        //---
        
        user.lastName <? nil
        
        Assert("'nil' is VALID for 'lastName'").isTrue
        {
            user.lastName.isValid
        }
        
        user.lastName <? ""
        
        Assert("Empty string is VALID for 'lastName'").isTrue
        {
            user.lastName.isValid
        }
        
        user.lastName.draft = "ldfewihfiqeuwbfweiubf"
        
        Assert("A random non-empty string is VALID for 'lastName'").isTrue
        {
            user.lastName.isValid
        }
    }
}
