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
    var internalValue: Value? = nil // you can force to have non-nil value in the validator
    
    fileprivate
    var valueSetOnce = false
    
    public
    let mutable: Bool
    
    fileprivate
    let validator: (Value) -> Bool
    
    //===
    
    public
    init(value initialValue: Value,
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
        self.init(value: constValue, mutable: false, validator: { _ in return true })
    }
}

//===

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
    
    func setValue<T>(_ newValue: T?) throws
    {
        guard
            notInitializedOrMutable()
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
        valueSetOnce = true
    }
}

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
            notInitializedOrMutable()
        else
        {
            return false
        }
        
        //===
        
        guard
            let newValue = newValue as? Value,
            validator(newValue)
        else
        {
            return false
        }
        
        //===
        
        return true
    }
}

//===

fileprivate
extension ValueWrapper
{
    func notInitializedOrMutable() -> Bool
    {
        return !valueSetOnce || mutable
    }
}
