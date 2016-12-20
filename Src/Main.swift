//
//  Main.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 8/27/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import MKHRequirement

//===

public
struct ValidatableValue<Value>
{
    var internalValue: Value?
    
    let requirements: [Requirement<Value>]
    
    //===
    
    public
    let mutable: Bool
    
    //===
    
    public
    init(mutable: Bool = false,
         _ requirements: Requirement<Value>...)
    {
        self.internalValue = nil
        
        //===
        
        self.mutable = mutable
        self.requirements = requirements
    }
    
    public
    init(value initialValue: Value?,
         mutable: Bool = false,
         _ requirements: Requirement<Value>...) throws
    {
        self.mutable = mutable
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
