//
//  Main.swift
//  MKHValueWrapper
//
//  Created by Maxim Khatskevich on 8/27/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

public
struct ValueWrapper<Value>
{
    var internalValue: Value?
    
    let validator: (Value) -> Bool
    
    //===
    
    public
    let mutable: Bool
    
    //===
    
    public
    init(mutable: Bool = false,
         validator: @escaping (Value) -> Bool)
    {
        self.internalValue = nil
        
        //===
        
        self.mutable = mutable
        self.validator = validator
    }
    
    public
    init(value initialValue: Value?,
         mutable: Bool = false,
         validator: @escaping (Value) -> Bool) throws
    {
        guard
            initialValue.map(validator) ?? mutable
        else
        {
            throw InvalidValue()
        }
        
        //===
        
        self.internalValue = initialValue
        
        //===
        
        self.mutable = mutable
        self.validator = validator
    }
}

//=== MARK: - Special initializer

public
extension ValueWrapper
{
    init(const constValue: Value)
    {
        try! self.init(value: constValue,
                       mutable: false,
                       validator: { _ in return true })
    }
}
