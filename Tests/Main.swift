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
    var user = User()
}

// MARK: - Overrides

extension MainTests
{
    override
    func setUp()
    {
        super.setUp()

        //---
        
        user = User()
    }
}

// MARK: - Tests

extension MainTests
{
    func testConstVV()
    {
        Assert("Const number value is valid").isNotNil
        {
            try? 42.validatableConst()
        }

        //---

        let correctEmail = "john@google.com"

        Assert("Correct const email value is valid").isNotNil
        {
            try? User.Email.validatable(const: correctEmail)
        }

        //---

        let incorrectEmail = "john@google"

        Assert("Incorrect const email value is NOT valid").isNil
        {
            try? User.Email.validatable(const: incorrectEmail)
        }

        //---

        Assert("Correct const email value is valid").isTrue
        {
            User.Email?.validatable(initialValue: correctEmail).isValid
        }

        //---

        Assert("Incorrect const email value is NOT valid").isFalse
        {
            User.Email.validatable(initialValue: incorrectEmail).isValid
        }

        //---

        Assert("EMPTY optional email value is valid").isTrue
        {
            User.Email?.validatable().isValid
        }

        //---

        do
        {
            _ = try User.Email.validatable(const: incorrectEmail)

            XCTFail("Should not get here ever")
        }
        catch
        {
            print(error)
        }
    }

    func testWholeUserIsValid()
    {
        user.firstName <? "Max"
        user.lastName <? "Kevi"
        user.username <? "maxim@google.com"
        // forgot password...

        Assert("Whole entity is NOT valid yet").isFalse
        {
            user.isValid
        }

        user.password <? "123t5y7gh"

        Assert("Whole entity is NOT valid yet").isFalse
        {
            user.isValid
        }

        // because...

        Assert("Password value is NOT valid yet").isFalse
        {
            user.password.isValid
        }

        do
        {
            try user.validate()
        }
        catch
        {
            print(error) // see in  console for detailed explanation what's failed!
        }

        // now lets improve the password to satisfy ALL conditions

        user.password <? "!C3t5y7gh"

        Assert("Whole entity is valid").isTrue
        {
            user.isValid
        }
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
            try user.someConstant.validValue() == User.someConstantValue
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
                error is ValidationFailed
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
            user.firstName.value == firstName
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
            user.firstName.value == anotherFirstName
        }
        
        Assert("'firstName' is now VALID").isTrue
        {
            user.firstName.isValid
        }
    }
}
