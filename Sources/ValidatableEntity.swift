protocol ValidatableEntity
{
    var isValid: Bool { get }
    func validate() throws
}

//===

//extension ValidatableEntity
//{
//    func validate<T>(
//        _ propGetter: (BaseEntity) -> T,
//        _ requirements: Requirement<T>...
//        ) -> ValidatableValue<T>
//    {
//        return ValidatableValue(
//            propGetter(entity),
//            requirements
//        )
//    }
//
//    func validate<T>(
//        _ propGetter: (BaseEntity) -> T?,
//        _ requirements: Requirement<T>...
//        ) -> ValidatableValue<T>
//    {
//        return ValidatableValue(
//            propGetter(entity).flatMap { $0 },
//            requirements
//        )
//    }
//}

//===

//struct Pub: Entity
//{
//    var firstPic: Data?
//    var secondPic: Data?
//    var comment: String?
//}
//
//struct VPub: ValidatableEntity
//{
//    var entity: Pub
//
//    //===
//
//    var firstPicture: ValidatableValue<Data>
//    {
//        return validate(
//            { $0.firstPic },
//            Require("Non-empty") { _ = $0; return true }
//        )
//    }
//
//    var comment: ValidatableValue<String?>
//    {
//        return validate(
//            { $0.comment },
//            Require("Non-empty") { _ = $0; return true }
//        )
//    }
//}
