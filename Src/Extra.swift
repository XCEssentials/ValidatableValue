//
//  Extra.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/20/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import MKHRequirement

//===

public
extension ValidatableValue
{
    init(const constValue: Value)
    {
        self.mutable = false
        self.requirements = []
        self.internalValue = constValue
    }
    
    public
    init(mutable: Bool = false)
    {
        self.internalValue = nil
        
        //===
        
        self.mutable = mutable
        self.requirements = []
    }
    
    public
    init(value initialValue: Value?,
         mutable: Bool = false)
    {
        self.mutable = mutable
        self.requirements = []
        self.internalValue = initialValue
    }
}
