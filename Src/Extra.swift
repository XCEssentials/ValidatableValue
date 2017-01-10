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
    public
    init(_ initialValue: Value?)
    {
        self.requirements = []
        self.internalValue = initialValue
    }
    
    public
    init(_ requirements: Requirement<Value>...)
    {
        self.requirements = requirements
        self.internalValue = nil
    }
}
