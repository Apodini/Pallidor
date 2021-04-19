import Foundation

public extension String {
    /// returns true if the type defined in this string is of type String, Int, Int32, Int64, Double, Bool, Date or UUID, or an array or dictionary with keys and values of them. Optionals of the aforementioned types are also considered as primitives
    var isPrimitiveType: Bool {
        if isArrayType {
            return isPrimitiveArrayType
        }
        
        if isDictionaryType {
            return isPrimitiveDictionary
        }
        
        return PrimitiveType.check(type: unwrapped)
    }

    /// returns true if the type defined in this string is Int, Int32, Int64 or optional of them
    var isInteger: Bool {
        [.int, .int32, .int64].contains(PrimitiveType(rawValue: unwrapped))
    }

    /// returns true if the type defined in this string is Bool or optional of it
    var isBool: Bool {
        PrimitiveType(rawValue: unwrapped) == .bool
    }

    /// returns true if the type defined in this string is Double or optional of it
    var isDouble: Bool {
        PrimitiveType(rawValue: unwrapped) == .double
    }

    /// returns true if the type defined in this string is String or optional of it
    var isString: Bool {
        PrimitiveType(rawValue: unwrapped) == .string
    }
    
    /// returns true if the type defined in this string is an array
    var isArrayType: Bool {
        isCollectionType && !contains(":")
    }
    
    /// returns true if the type of array defined in this string is primitive
    var isPrimitiveArrayType: Bool {
        guard isArrayType else { return false }
        
        return withoutSquareBrackets.isPrimitiveType
    }
    
    /// returns true if the type defined in this string is dictionary
    var isDictionaryType: Bool {
        isCollectionType && contains(":")
    }
    
    /// returns true if it is a dictionary with primitive key and value type
    var isPrimitiveDictionary: Bool {
        guard isDictionaryType else { return false }
        
        let types = String(trimmingCharacters(in: .whitespaces).withoutSquareBrackets).split(separator: ":")
        
        if let keyType = types.first, let valueType = types.last {
            return String(keyType).isPrimitiveType && String(valueType).isPrimitiveType
        }
        return false
    }
    
    /// returns true if the type defined in this string is a collection (array or dictionary) type in Swift
    var isCollectionType: Bool {
        first == "[" && unwrapped.last == "]"
    }

    /// returns true if the type defined in this string has a trailing `?`
    var isOptional: Bool {
        last == "?"
    }

    /// returns the type name without `?` if type is an optional
    var unwrapped: String {
        isOptional ? String(dropLast()) : self
    }

    /// returns the type name with `?` if type is not already an optional
    var wrapped: String {
        !isOptional ? "\(self)?" : self
    }

    /// returns the type of items inside an array
    var itemType: String {
        withoutSquareBrackets
    }
    
    /// used to remove square brackets and `?` on arrays and dictionaries
    var withoutSquareBrackets: String {
        String(unwrapped.dropFirst().dropLast())
    }
}
