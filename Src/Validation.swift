//
//  Validation.swift
//  MKHValueWrapper
//
//  Created by Maxim Khatskevich on 12/6/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
extension ValueWrapper
{
    func isValid() -> Bool
    {
        return internalValue.map(validator) ?? false
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
            (newValue as? Value).map(validator) ?? false
            else
        {
            return false
        }
        
        //===
        
        return true
    }
}
