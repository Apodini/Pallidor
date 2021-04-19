//
//  Variable+ConvertFrom.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

extension WrappedVariable {
    /// unmodified version for `from()` method
    var unmodifiedFrom: String {
        guard isMutable else {
            return ""
        }
        
        if isEnum {
            return enumInit
        }
        
        if isTypeAlias && typeName.isPrimitiveType {
            return defaultInit
        }
        
        if isCustomType && isArray {
            return customArrayTypeInit
        }
        
        if isCustomType && isDictionary {
            return customDictionaryTypeInit
        }
        
        if isCustomType {
            return customTypeInit
        }
        
        if isCustomInternalEnumType {
            return customInternalEnumInit
        }
        
        return defaultInit
    }
    
    /// initializer string for enum type
    private var enumInit: String {
        "self.\(name) = \(typeName.name.unwrapped)(from.\(name))\(isOptional ? "" : "!")"
    }
    
    /// initializer string for internal enum type
    private var customInternalEnumInit: String {
        "self.\(name) = \(typeName.name.unwrapped)(from.\(name))\(isOptional ? "" : "!")"
    }
    
    /// initializer string for custom types
    private var customTypeInit: String {
        "self.\(name) = \(typeName.name.unwrapped)(from.\(name))\(isOptional ? "" : "!")"
    }
    
    /// initializer string for custom array types
    private var customArrayTypeInit: String {
        "self.\(name) = from.\(name)\(isOptional ? "?" : "").compactMap({ \("\(typeName.arrayElementType)($0)") })"
    }
    
    /// initializer string for custom dictionary types
    private var customDictionaryTypeInit: String {
        "self.\(name) = from.\(name)\(isOptional ? "?" : "").compactMapValues { \("\(typeName.dictionaryValueType)($0)") }"
    }
    
    /// default initializer string
    private var defaultInit: String {
        "self.\(name) = from.\(name)"
    }
    
    /// replacement string for `from()` method
    func replacedFrom(_ name: String) -> String {
        "self.\(self.name) = \(name)"
    }
}
