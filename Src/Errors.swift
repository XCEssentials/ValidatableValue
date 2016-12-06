//
//  Errors.swift
//  MKHValidatableValue
//
//  Created by Maxim Khatskevich on 8/27/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

public
protocol ValidatableValueError: Error { }

//===

public
struct MutabilityViolation: ValidatableValueError { }

public
struct InvalidValue: ValidatableValueError { }
