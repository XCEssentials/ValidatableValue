//
//  Errors.swift
//  MKHValueWrapper
//
//  Created by Maxim Khatskevich on 8/27/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//

public
protocol ValueWrapperError: Error { }

//===

public
struct MutabilityViolation: ValueWrapperError { }

public
struct InvalidValue: ValueWrapperError { }
