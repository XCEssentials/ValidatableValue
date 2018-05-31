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
