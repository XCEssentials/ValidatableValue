[![license](https://img.shields.io/github/license/XCEssentials/ValidatableValue.svg)](https://opensource.org/licenses/MIT)
[![GitHub tag](https://img.shields.io/github/tag/XCEssentials/ValidatableValue.svg)](https://cocoapods.org/?q=XCERequirement)
[![CocoaPods](https://img.shields.io/cocoapods/v/XCEValidatableValue.svg)](https://cocoapods.org/?q=XCERequirement)
[![CocoaPods](https://img.shields.io/cocoapods/p/XCEValidatableValue.svg)](https://cocoapods.org/?q=XCEUniFlow)

# Problem

Every app has [data model](https://en.wikipedia.org/wiki/Data_model). A data model is usually implemented in the form of a custom composite [data type](https://en.wikipedia.org/wiki/Data_type) that stores one or more [properties](https://en.wikipedia.org/wiki/Property_(programming)). Ideally, the type of each property (no matter if it's atomic or composite) defines desired set of all possible values for this property. Plus, there are might be special rules that may define whatever any given value is acceptable for the property or not.

Swift has no built-in mechanizm of how to narrow-down set of allowed values within one of the standard data types and/or evaluate any special rules against each given value to check if it's acceptable for the property or not.

For example, to limit a vlaue to just integer numbers in the range from 1 to 100 and avoid all odd numbers within this range we usually use just Integer, and then somehow later implement the needed checks before actually put a value in this property. That leads to distribution of single portion of business logic (requirements for this particualr property) across at least two (sometimes more) places in the codebase.

# Wishlist

1. concise inline definition of value validation logic;
2. safe value validation before actually writing it into property;
3. combination of several requirements together to create composite requirement that defines custom allowed values set;
4. eliminate any side effects by making validation logic to be written as pure function.

# How to install

The recommended way is to install using [CocoaPods](https://cocoapods.org/?q=XCEValidatableValue).

# How it works

The `ValidatableValue` data type represents a value that can be validated against custom rules/requirements. It also relies on `Value` generic type that represents base data type for potential value (one of the standard system data types or any custom one). The validation logic must be supplied as input parameter to the constructor in form of set of [Requirement](https://github.com/XCEssentials/Requirement) instances (might be empty in an edge case when any value of the base type is fine). There are several ways of creating a validatable value, see below.

# How to use

Assume we need to define a basic data model for representing user in our app.

Import necessery libraries like this:

```swift
import XCEValidatableValue
import XCERequirement
```

Lets decalre type called `MyUser`:

```swift
struct MyUser
{
	// ...
}
```

Inside this type lets define instance-level variables of type `ValidatableValue`, one for each property.

We can create a constant value, that does not accept any input at all (an edge case), so we declare it as `let`:

```swift
let someConstantValue = ValidatableValue(3)
```

Here is the simplest example of validatable value with single validation requirement:

```swift
var firstName = ValidatableValue<String>(
    Require("Non-empty") { $0.characters.count > 0 } )
```

Notice, that we declare this value as `var`, becasue by default the value is empty and needs to be set with a value that passes validation to whole value become valid.

It's also okay to create a validatable value with no validation rules. it's an edge case and brings no value over just using the base data type, but allows to unify source code and approach on working with data model properties. See example below.

```swift
var lastName = ValidatableValue<String?>()
    // no requirements on value, even "nil" is okay
```

Here is an example fo complex validation logic that consists of several requirements.

```swift
var password = ValidatableValue<String>(
    Require("Lenght between 8 and 30 characters"){ 8...30 ~= $0.characters.count },
    Require("At least 1 capital character"){ 1 <= Pwd.caps.count(at: $0) },
    Require("At least 4 lower characters"){ 4 <= Pwd.lows.count(at: $0) },
    Require("At least 1 digit character"){ 1 <= Pwd.digits.count(at: $0) },
    Require("At least 1 special character"){ 1 <= Pwd.specials.count(at: $0) },
    Require("Valid characters only"){ Pwd.allowed.isSuperset(of: CS(charactersIn: $0)) })
```

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

Later we can create an instance of data model without worrying about required values provided right away (convenient for cases when you need to store and validate data before it will be saved and submitted to server for persisting). Note, that developer is repsonsible for defining what combination of valid propeties means that whole data model is valid and ready to be saved in long-term/external memory.

Here is how we create an instanc of user model:

```swift
let u = MyUser()
```

At any point of time we can check if a value is valid at the moment:

```swift
u.someConstantValue.isValid() // constants will always return 'true'
```

Here is how we access actual value, it will throw an `InvalidValue` error in case the value does not pass validation:

```swift
try u.someConstantValue.value()
```

To set value, use `setValue` method that accepts data of any type and will throw error if passed value does not pass validation, or updated internally stored value and pass through silently (whole validateable value becomes valid in this case):

```swift
let newVal: Any = //...
try u.firstName.setValue(newVal)
```

See full example in [unit tests](https://github.com/XCEssentials/ValidatableValue/tree/master/Tst).