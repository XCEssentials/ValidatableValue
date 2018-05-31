//
//  Helpers.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/20/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

typealias CS = CharacterSet // swiftlint:disable:this type_name

// MARK: - CharacterSet helpers

extension CS
{
    func count(at str: String) -> UInt
    {
        var result: UInt = 0
        
        //===

        //swiftlint:disable:next identifier_name
        for c in str
            where String(c).rangeOfCharacter(from: self) != nil
        {
            result += 1
        }
        
        //===
        
        return result
    }
}

// MARK: - String helpers

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
