//
//  Helpers.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 12/6/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

extension ValidatableValue
{
    func notInitialized() -> Bool
    {
        return internalValue == nil
    }
}
