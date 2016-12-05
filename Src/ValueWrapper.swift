//
//  ValueWrapper.swift
//  MKHValueWrapper
//
//  Created by Maxim Khatskevich on 8/27/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

public
final
class ValueWrapper<Value>
{
    fileprivate
    var internalValue: Value? = nil
    
    fileprivate
    let validator: (Value) -> Bool
    
    //===
    
    public
    let mutable: Bool
    
    //===
    
    public
    init(value initialValue: Value? = nil,
         mutable: Bool = false,
         validator: @escaping (Value) -> Bool)
    {
        self.mutable = mutable
        self.validator = validator
        
        //===
        
        try? setValue(initialValue)
    }
}

//===

public
extension ValueWrapper
{
    public
    convenience
    init(const constValue: Value)
    {
        self.init(value: constValue,
                  mutable: false,
                  validator: { _ in return true })
    }
}

//=== Value access

public
extension ValueWrapper
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
            validator(newValue)
        else
        {
            throw InvalidValue()
        }
        
        //===
        
        internalValue = newValue
    }
}

//=== Validation

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
            let newValue = newValue as? Value,
            validator(newValue)
            
            // alternative expression:
            // (newValue as? Value).map(validator) ?? false
        else
        {
            return false
        }
        
        //===
        
        return true
    }
}

//=== Helpers

fileprivate
extension ValueWrapper
{
    func notInitialized() -> Bool
    {
        return internalValue == nil
    }
}
