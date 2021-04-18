//
//  WrappedTypeName.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

/// Wrapped types of sourcery types
class WrappedTypeName {
    internal init(name: String, actualName: String, isOptional: Bool, isArray: Bool, isVoid: Bool, isPrimitive: Bool) {
        self.name = name
        self.actualName = actualName
        self.isOptional = isOptional
        self.isArray = isArray
        self.isVoid = isVoid
        self.isPrimitive = isPrimitive
    }

    /// name of type
    var name: String
    /// name of actual type
    var actualName: String
    /// true if type is optional
    var isOptional: Bool
    /// true if type is array
    var isArray: Bool
    /// true if type is void
    var isVoid: Bool
    /// true if type is primitive
    var isPrimitive: Bool
    /// true if type is a type alias
    var isTypeAlias: Bool {
        name != actualName
    }
    /// true if type is a primitive type
    var isPrimitiveType: Bool {
        isTypeAlias ? actualName.isPrimitiveType : name.isPrimitiveType
    }

    convenience init(from: TypeName) {
        let persistentName = from.isArray ? from.name.replacingOccurrences(of: "_", with: "") : from.name.removePrefix
        self.init(
            name: persistentName,
            actualName: persistentName,
            isOptional: from.isOptional,
            isArray: from.isArray,
            isVoid: from.isVoid,
            isPrimitive: persistentName.isPrimitiveType
        )
    }
}
