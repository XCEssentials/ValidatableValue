//
//  ValueAccess.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/6/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

public
extension ValidatableValue
{
    func value() throws -> Value
    {
        guard
            let result = internalValue
        else
        {
            throw InvalidValue()
        }
        
        //===
        
        return result
    }
    
    func copy(with newValue: Value) throws -> ValidatableValue
    {
        return try ValidatableValue(newValue, requirements)
    }
    
    mutating
    func setValue(_ newValue: Value) throws
    {
        guard
            validate(newValue)
        else
        {
            throw InvalidValue()
        }
        
        //===
        
        internalValue = newValue
    }
}
