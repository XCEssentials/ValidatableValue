//
//  Validation.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/6/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

public
extension ValidatableValue
{
    func isValid() -> Bool
    {
        return validate(internalValue)
    }
    
    func mightBeSet<T>(with newValue: T) -> Bool
    {
        guard
            notInitialized() || mutable
        else
        {
            return false
        }
        
        //===
        
        guard
            validate(newValue as? Value)
        else
        {
            return false
        }
        
        //===
        
        return true
    }
}
