import Foundation

/// Contains all cases of the types trated as primitive in Pallidor
enum PrimitiveType: String, RawRepresentable {
    case string = "String"
    case int = "Int"
    case int32 = "Int32"
    case int64 = "Int64"
    case double = "Double"
    case bool = "Bool"
    case date = "Date"
    case uuid = "UUID"
    
    /// Checks whether the passed string matches the raw value of any of the supported primitive types
    static func check(type: String) -> Bool {
        PrimitiveType(rawValue: type) != nil
    }
}
