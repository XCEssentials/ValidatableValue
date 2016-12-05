//
//  Helpers.swift
//  MKHValueWrapper
//
//  Created by Maxim Khatskevich on 12/6/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

extension ValueWrapper
{
    func notInitialized() -> Bool
    {
        return internalValue == nil
    }
}
