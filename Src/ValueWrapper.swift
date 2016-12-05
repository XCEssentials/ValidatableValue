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
    public fileprivate(set)
    var value: Value? = nil // you can force to have non-nil value in the validator
    
    fileprivate
    var valueSetOnce = false
    
    public
    let mutable: Bool
    
    fileprivate
    let validator: (Value?) -> Bool
    
    //===
    
    public
    init(
        mutable: Bool,
        validator: @escaping (Value?) -> Bool)
    {
        self.mutable = mutable
        self.validator = validator
    }
    
    
    public
    init(initialValue: Value?,
         validator: @escaping (Value?) -> Bool)
    {
        self.value = initialValue
        self.mutable = true
        self.validator =  validator
    }
    
    public
    init(constant value: Value?)
    {
        self.value = value
        self.valueSetOnce = true
        self.mutable = false
        self.validator =  { _ in return true }
    }
    
    public
    init(
        mutable: Bool = false,
        acceptNil: Bool = false,
        validator: @escaping (Value) -> Bool)
    {
        self.mutable = mutable
        self.validator = { $0.map(validator) ?? acceptNil }
    }
}

//===

public
extension ValueWrapper
{
    func setValue<T>(_ externalValue: T?) throws
    {
        guard
            !valueSetOnce || mutable
        else
        {
            throw MutabilityViolation()
        }
        
        //===
        
        let newValue = externalValue as? Value
        
        //===
        
        guard
            validator(newValue)
        else
        {
            throw
                InvalidValue()
        }
        
        //===
        
        value = newValue
        valueSetOnce = true
    }
}

//===

public
extension ValueWrapper
{
    func isValid() -> Bool
    {
        return validator(value)
    }
    
    func mightBeSet<T>(with newValue: T) -> Bool
    {
        return !valueSetOnce
            && validator(newValue as? Value)
    }
}
