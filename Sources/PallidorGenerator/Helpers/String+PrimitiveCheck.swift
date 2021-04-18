//
//  String+PrimitiveCheck.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

extension String {
    /// returns true if the type defined in this string matches the regex pattern of a primitive type in Swift
    var isPrimitiveType: Bool {
        let mappedType = TypeAliases.store[self]
        
        guard let actualType = mappedType else {
            guard let result = try? !NSRegularExpression(
                pattern: "\\[?\\s*((String|Int(32|64)?|Double|Bool|Date)\\s*:\\s*)?(String|Int(32|64)?|Double|Bool|Date)\\s*\\]?"
            )
            .matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)).isEmpty else {
                fatalError("Initialization of RegEx tester failed.")
            }
            return result
        }
        
        return actualType.isArray ?
            String(actualType.dropFirst().dropLast()).isPrimitiveType :
            actualType.isPrimitiveType
    }
    
    /// returns true if the type defined in this string matches the regex pattern of a primitive dictionary type in Swift
    var isPrimitiveDictionary: Bool {
        guard let result = try? !NSRegularExpression(
            pattern: "\\[\\s*(String|Int(32|64)?|Double|Date)\\s*:\\s*(String|Int(32|64)?|Double|Bool|Date)\\s*\\]"
        )
        .matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)).isEmpty
        else {
            fatalError("Initialization of RegEx tester failed.")
        }
        return result
    }
    
    /// returns true if the type defined in this string matches the regex pattern of a primitive array type in Swift
    var isPrimitiveArray: Bool {
        guard let result = try? !NSRegularExpression(
            pattern: "\\[\\s*(String|Int(32|64)?|Double|Bool|Date)\\s*\\]"
        ).matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)).isEmpty
        else {
            fatalError("Initialization of RegEx tester failed.")
        }
        return result
    }
    
    /// returns true if the type defined in this string matches the regex pattern of an array type in Swift
    var isArray: Bool {
        guard let result = try? !NSRegularExpression(pattern: "\\[\\w*\\]")
                .matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)).isEmpty else {
            fatalError("Initialization of RegEx tester failed.")
        }
        return result
    }
    
    /// removes a leading `_` from the string if one exists
    var removePrefix: String {
        self.first == "_" ? self.replacingOccurrences(of: "_", with: "") : self
    }
}
