[![GitHub License](https://img.shields.io/github/license/XCEssentials/ValidatableValue.svg?longCache=true)](LICENSE)
[![GitHub Tag](https://img.shields.io/github/tag/XCEssentials/ValidatableValue.svg?longCache=true)](https://github.com/XCEssentials/ValidatableValue/tags)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?longCache=true)](Package.swift)
[![Written in Swift](https://img.shields.io/badge/Swift-5.3-orange.svg?longCache=true)](https://swift.org)
[![Supported platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-blue.svg?longCache=true)](Package.swift)
[![Build Status](https://travis-ci.com/XCEssentials/ValidatableValue.svg?branch=master)](https://travis-ci.com/XCEssentials/ValidatableValue)

# ValidatableValue

Generic value wrapper with built-in declarative validation.

## Problem

Every app has [data model](https://en.wikipedia.org/wiki/Data_model). A data model is usually implemented as a custom structured [data type](https://en.wikipedia.org/wiki/Data_type) that stores one or more [properties](https://en.wikipedia.org/wiki/Property_(programming)). Ideally, the type of each property (no matter if it's of primitive or structured type) defines desired set of all possible values for this property. Plus, there are might be special rules that may define whatever any given value is acceptable for the property or not.

Swift has no built-in mechanism of how to narrow-down set of allowed values within one of the standard data types and/or evaluate any special rules against each given value to check if it's acceptable for the property or not.

For example, to limit a vlaue to just integer numbers in the range from 1 to 100 and avoid all odd numbers within this range we usually use just Integer, and then somehow later implement the needed checks before actually put a value in this property. That leads to distribution of single portion of business logic (requirements for this particualr property) across at least two (sometimes more) places in the codebase.

## Wishlist

1. concise declarative definition of value validation logic;
2. safe value validation before actually writing it into property;
3. ability to combine several requirements together to describe complex validation rules;
4. eliminate any side effects by making validation logic to be written as pure function on type level.

## How to install

The recommended way is to install using [SwiftPM](https://swift.org/package-manager/), but [Carthage](https://github.com/Carthage/Carthage) is also supported out of the box..

## Quick example

To describe custom validation rules for user account password let's define so called `ValueSpecification`. Such specification defines value base type (any pre-defined data type) plus set of requirements that need to be fulfilled in order to pass validation.

```swift
enum Password: ValueSpecification
{
    static
    let conditions: [Condition<String>] = [

        Check("Lenght between 8 and 30 characters"){ 8...30 ~= $0.count },
        Check("Has at least 1 capital character"){ 1 <= Pwd.caps.count(in: $0) },
        Check("Has at least 4 lower characters"){ 4 <= Pwd.lows.count(in: $0) },
        Check("Has at least 1 digit character"){ 1 <= Pwd.digits.count(in: $0) },
        Check("Has at least 1 special character"){ 1 <= Pwd.specials.count(in: $0) },
        Check("Allowed chars only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) }
    ]
}
```

Note, that `Password` is declared as enum, because we only need it as a scope, it won't be instantiated directly — its name defines name of the specification and also inside we specify `conditions` (a.k.a. requirements) that must be fulfilled in oreder to pass validation.

In the example above we use simple custom helpers defined like this:

```swift
enum Pwd
{
    static
    let caps = CS.uppercaseLetters

    static
    let lows = CS.lowercaseLetters

    static
    let digits = CS.decimalDigits

    static
    let specials = CS(charactersIn: " ,.!?@#$%^&*()-_+=")

    static
    var allowed = caps.union(lows).union(digits).union(specials)
}
```

## How to use

See [User.swift](User.swift) in [unit tests](https://github.com/XCEssentials/ValidatableValue/tree/master/Tests/AllTests) for comprehensive up-to-date example of usage.
