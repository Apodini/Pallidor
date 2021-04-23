import Foundation

/// Contains all cases of the types trated as primitive in Pallidor
enum PrimitiveType: String, RawRepresentable {
    case int = "Int"
    case int32 = "Int32"
    case int64 = "Int64"
    case uint = "UInt"
    case uint32 = "UInt32"
    case uint64 = "UInt64"
    case bool = "Bool"
    case string = "String"
    case double = "Double"
    case float = "Float"
    
    case uuid = "UUID"
    case date = "Date"
    
    /// Checks whether the passed string matches the raw value of any of the supported primitive types
    static func check(type: String) -> Bool {
        let trimmed = type.trimmingCharacters(in: .whitespaces)
        return PrimitiveType(rawValue: trimmed) != nil
    }
}
