//
//  Password.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/20/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import Foundation

//---

enum Pwd
{
    static
    let caps = CS.uppercaseLetters
    
    static
    let lows = CS.lowercaseLetters
    
    static
    let digits = CS.decimalDigits
    
    static
    let specials = CS(charactersIn: " ,.!?@#$%^&*()-_+=")
    
    static
    var allowed = caps.union(lows).union(digits).union(specials)
}
