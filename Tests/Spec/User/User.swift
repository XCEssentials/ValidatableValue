//
//  User.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/20/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCEValidatableValue

//---

struct MyUser
{
    static
    let someConstantValue = 3
    
    let someConstant = MandatoryValue(initialValue: MyUser.someConstantValue)

    var firstName = String.nonEmpty

    var lastName = OptionalValue<String>()
        // no requirements on value, even "nil" is okay

    var username = String.nonEmpty
        .check("Valid email address", String.isValidEmail)

    var password = MandatoryValue<String>(
        Check("Lenght between 8 and 30 characters"){ 8...30 ~= $0.count },
        Check("At least 1 capital character"){ 1 <= Pwd.caps.count(at: $0) },
        Check("At least 4 lower characters"){ 4 <= Pwd.lows.count(at: $0) },
        Check("At least 1 digit character"){ 1 <= Pwd.digits.count(at: $0) },
        Check("At least 1 special character"){ 1 <= Pwd.specials.count(at: $0) },
        Check("Valid characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) })
}

// MARK: - Helpers

fileprivate
extension String
{
    static
    let nonEmpty = MandatoryValue<String>(
        Check("Non-empty") { !$0.isEmpty })
}

