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
    
    mutating
    func setValue<T>(_ newValue: T) throws
    {
        guard
            notInitialized() || mutable
        else
        {
            throw MutabilityViolation()
        }
        
        //===
        
        guard
            let newValue = newValue as? Value,
            validate(newValue)
        else
        {
            throw InvalidValue()
        }
        
        //===
        
        internalValue = newValue
    }
}
