//
//  Main.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 8/27/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import XCERequirement

//===

public
struct ValidatableValue<Value>
{
    var internalValue: Value?
    
    let requirements: [Requirement<Value>]
    
    //===
    
    public
    init(_ initialValue: Value?,
         _ requirements: Requirement<Value>...) throws
    {
        try self.init(initialValue, requirements)
    }
    
    //===
    
    init(_ initialValue: Value?,
         _ requirements: [Requirement<Value>]) throws
    {
        self.requirements = requirements
        
        //===
        
        guard
            validate(initialValue)
        else
        {
            throw InvalidValue()
        }
        
        //===
        
        self.internalValue = initialValue
    }
}
