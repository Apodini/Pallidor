//
//  EnumModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// enum model as stated in open api document
class EnumModel: Schema {
    var detail: String?
    
    
    var description: String {
            """
            import Foundation

            \(detail == nil ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                "" : "/** " + detail!.removeOAIIllegalCharacters() + " */")
            
            enum _\(name): \(enumType), Codable {
            
            \(enumValues.map { enumType == "String" ? "case \($0.removeOAIIllegalCharacters()) = \"\($0)\"\n" : "case _\($0) = \($0)" }.joined())
            
            }

            """
    }
    
    /// name of enum
    var name: String
    /// values of enum
    var enumValues: [String]
    /// primitive type of enum (e.g. String)
    var enumType: String
    
    init(name: String, enumValues: [String], enumType: String, detail: String?) {
        self.name = name
        self.enumValues = enumValues
        self.enumType = enumType
        self.detail = detail
    }
}
