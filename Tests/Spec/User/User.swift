//
//  User.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/20/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCEValidatableValue

//===

struct MyUser
{
    static
    let someConstantValue = 3
    
    let someConstant = MandatoryValue(MyUser.someConstantValue)
    
    var email = Email()
    
    var firstName = FirstName()

    var lastName = OptionalValue<String>()
        // no requirements on value, even "nil" is okay

    var password = Password()
}

// MARK: Value validation

extension MyUser
{
    struct Email: MandatoryValidatable { typealias Value = String
        
        static
        let validations = [
            
            Validate("Valid email address", String.isValidEmail)
        ]
        
        var draft: Draft
        
        init() { }
    }
    
    struct FirstName: MandatoryValidatable { typealias Value = String
        
        static
        let validations = [
            
            Validate<Value>("Non-empty") { !$0.characters.isEmpty }
        ]
        
        var draft: Draft
        
        init() { }
    }
    
    struct Password: MandatoryValidatable { typealias Value = String
        
        static
        let validations = [
            
            Validate("Lenght between 8 and 30 characters"){ 8...30 ~= $0.characters.count },
            Validate("At least 1 capital character"){ 1 <= Pwd.caps.count(at: $0) },
            Validate("At least 4 lower characters"){ 4 <= Pwd.lows.count(at: $0) },
            Validate("At least 1 digit character"){ 1 <= Pwd.digits.count(at: $0) },
            Validate("At least 1 special character"){ 1 <= Pwd.specials.count(at: $0) },
            Validate("Valid characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) }
        ]
        
        var draft: Draft
        
        init() { }
    }
}
