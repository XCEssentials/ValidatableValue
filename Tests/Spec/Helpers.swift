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

//===

extension CS
{
    func count(at str: String) -> UInt
    {
        var result: UInt = 0
        
        //===
        
        for c in str.characters
            where String(c).rangeOfCharacter(from: self) != nil
        {
            result += 1
        }
        
        //===
        
        return result
    }
}
