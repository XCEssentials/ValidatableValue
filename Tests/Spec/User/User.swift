//
//  User.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/20/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCEValidatableValue

import XCERequirement

//===

struct MyUser
{
    static
    let someConstantValue = 3
    
    let someConstant = ValidatableValue(MyUser.someConstantValue)
    
    var email = ValidatableValue<String>(
        Require("Valid email address", String.isValidEmail) )
    
    var firstName = ValidatableValue<String>(
        Require("Non-empty") { $0.characters.count > 0 })
    
    var lastName = ValidatableValue<String?>(nil)
        // no requirements on value, even "nil" is okay
    
    var password = ValidatableValue<String>(
        Require("Lenght between 8 and 30 characters"){ 8...30 ~= $0.characters.count },
        Require("At least 1 capital character"){ 1 <= Pwd.caps.count(at: $0) },
        Require("At least 4 lower characters"){ 4 <= Pwd.lows.count(at: $0) },
        Require("At least 1 digit character"){ 1 <= Pwd.digits.count(at: $0) },
        Require("At least 1 special character"){ 1 <= Pwd.specials.count(at: $0) },
        Require("Valid characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) })
}

//===

fileprivate
extension String
{
    static
    func isValidEmail(_ value: String) -> Bool
    {
        return value.isValidEmail()
    }
    
    func isValidEmail() -> Bool
    {
        let emailRegex =
            "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        return emailTest.evaluate(with: self)
    }
}
