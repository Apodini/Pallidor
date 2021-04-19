//
//  AttributeModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

class AttributeModel: Schema {
    /// comment for this attribute
    var detail: String?
    
    var description: String {
            var template =
            """
            \(detail == nil ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                "" : "/** " + detail!.removeOAIIllegalCharacters() + " */")\(isEnum ? "\n//sourcery: isEnumType" : (!isPrimitiveType ? "\n//sourcery: isCustomType" : ""))
            var \(name.lowerFirst()): \(isEnum ? name.upperFirst() : refType)\(!isRequired ? "?" : "")
            """
            
            if isEnum, let enumValues = self.enumValues {
                template +=
                """
                
                
                enum \(name.upperFirst()): \(type), Codable, CaseIterable {

                \(enumValues.map { type == "String" ? "case \($0.removeOAIIllegalCharacters()) = \"\($0)\"\n" : "case _\($0) = \($0)\n" }.joined())
                }
                """
            }
            
            return template
    }
    
    private var refType: String {
            var refType = type
            if NotOfResolver.notOfReferred.contains(type) {
                refType = type + "<T>"
            }
            if NotOfResolver.notOfReferences.contains(type) {
                refType = "\(type)<\(type[type.index(type.startIndex, offsetBy: 3)...]), T>"
            }
            return "\(isArray ? "[\(refType)]" : refType)"
    }
    
    private var isPrimitiveType: Bool {
        refType.isPrimitive
    }
    
    /// name of attribute
    var name: String
    /// type of attribute
    var type: String
    /// true if type of attribute is an array
    var isArray: Bool = false
    /// true if attribute is required in open api document
    var isRequired: Bool
    /// true if attribute type is an enum
    var isEnum: Bool {
            guard let enumVals = enumValues else {
                return false
            }
            return enumVals.count > 1
    }
    /// list of enum values if attribute is an enum
    var enumValues: [String]?
    
    init(name: String, type: String, isRequired: Bool, detail: String?) {
        self.name = name
        self.type = type
        self.isRequired = isRequired
        self.detail = detail
    }
}

extension AttributeModel {
    func alterIllegalName(objectName: String) -> AttributeModel {
        if isEnum && self.name == "type" {
            self.name = objectName + self.name.upperFirst()
        }
        if self.name == "extension" {
            self.name = "`\(name)`"
        }
        return self
    }
    
    func getInitializerString() -> String {
        "self." + name.lowerFirst() + " = " + name.lowerFirst()
    }
    
    func getInitParamString() -> String {
        "\(self.name.lowerFirst()): \(self.isEnum ? self.name.upperFirst() : self.refType)\(!self.isRequired ? "?" : ""), "
    }
}

extension AttributeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: AttributeModel, rhs: AttributeModel) -> Bool {
        lhs.name == rhs.name
    }
}
