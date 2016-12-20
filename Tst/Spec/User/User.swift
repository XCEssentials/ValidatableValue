//
//  User.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/20/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import MKHValidatableValue

import MKHRequirement
import MKHHelpers

//===

struct MyUser
{
    let someConstantValue = ValidatableValue(const: 3)
    
    var email = ValidatableValue<String>(
        Require("Valid email address", String.isValidEmail) )
    
    var firstName = ValidatableValue<String>(
        Require("Non-empty") { $0.characters.count > 0 } )
    
    var lastName = ValidatableValue<String?>()
        // no requirements on value, even "nil" is okay
    
    var password = ValidatableValue<String>(
        Require("Lenght between 8 and 30 characters"){ 8...30 ~= $0.characters.count },
        Require("At least 1 capital character"){ 1 <= Pwd.caps.countChars(at: $0) },
        Require("At least 4 lower characters"){ 4 <= Pwd.lows.countChars(at: $0) },
        Require("At least 1 digit character"){ 1 <= Pwd.digits.countChars(at: $0) },
        Require("At least 1 special character"){ 1 <= Pwd.specials.countChars(at: $0) },
        Require("Valid characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) })
}
