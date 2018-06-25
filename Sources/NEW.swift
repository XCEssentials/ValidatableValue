/*

 - Mandatory + ValueSpec -> validatable    // custom displayName
 - Mandatory             -> validatable    // intrinsic displayName

 - Optional + ValueSpec -> validatable     // custom displayName
 - Optional                                // intrinsic displayName

 //---

 protocol ValueWrapper {}
 protocol Mandatory {}

 // just regular Optional for storing optional value wihtout any conditions

 struct Custom<T: Spec>: ValueWrapper, Validatable { ... }
        Custom<T: Spec>?: ValueWrapper, Validatable

 struct MandatoryCustom<T: Spec>: ValueWrapper, Mandatory, Validatable { ... }
        MandatoryCustom<T: Spec>?: ValueWrapper, Validatable

 NOTE: it's a good idea to wrap a 'CustomValueWrapper' type in 'Swift.Optional'
 to be able to leverage default Swift 'Decodable' protocol implementaion
 and skip safely any values that are missing from given raw representation
 for the entity.

 String             --- String
 String?            --- String?

 // 'FirstName' is a value spec with few conditions

 FirstName.Wrapper  --- MandatoryCustom<FirstName>
 FirstName.Wrapper? --- MandatoryCustom<FirstName>?  ???? - mandatory inside optional??

 // 'LastName' is a value spec with NO conditions

 LastName.Wrapper   --- MandatoryCustom<LastName>   // like 'MandatoryBase'
 LastName.Wrapper?  --- MandatoryCustom<LastName>?  // like 'MandatoryBase?'

 FirstName?.Wrapper --- OptionalCustom<FirstName>    ????
 FirstName?.Wrapper? -- OptionalCustom<FirstName>?  ???? optional inside optional?

 What if we don't use 'OptionalCustom', just 'Custom' instead. 'Custom' gives us 'DisplayNamed' implementation, 'conditions' to check againts non-empty value, and non-optional 'value' itself when 'Custom' is present.
 'MandatoryCustom' would be exactly the same as 'Custom', but also has conformance to one more protocol 'Mandatory', so it indicates to the wrapping 'Optional' (when that's the case) that in case the value is missing - it must be considered as 'invalid', versus just 'Custom' does not control the missing value state and 'Optional' validates empty value with no issues, asking wrapper to validate value only when it's presented.
 All common functionality of 'MandatoryCustom' and just 'Custom' should be implemented via protocols.
 'ValueWrapper' and 'Mandatory' protocols still should be merged in single protocol 'MandatoryValueWrapper: ValueWrapper'.

 //---

let someConstant: MandatoryBasic<Int>? = someConstantValue.wrapped()

 var firstName: MandatoryCustom<FirstName>? = FirstName.wrapped()
 var firstName: FirstName.Wrapper? // Optional<Custom>

var lastName: OptionalCustom<LastName>? = LastName?.wrapped()

var phoneNum: OptionalBasic<String>? = String?.wrapped()

var username: MandatoryCustom<Username>? = Username.wrapped() //

var password: MandatoryCustom<Password>? = Password.wrapped() //

 https://gist.github.com/hannesoid/10a35895e4dc5d6f1bb6428f7d4d23a5

 */

//public
//struct Custom<T>: ValueWrapper,
//    WithCustomValue,
//    AutoCodable
//    where
//    T: ValueSpecification,
//    T.Value: Codable & Equatable
//{
//    public
//    typealias Specification = T
//
//    public
//    typealias Value = Specification.Value
//
//    public
//    var value: Value
//
//    public
//    init(_ value: Value) { self.value = value }
//}
