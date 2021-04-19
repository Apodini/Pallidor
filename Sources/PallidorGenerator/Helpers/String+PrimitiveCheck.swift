//
//  String+PrimitiveCheck.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

extension String {
    /// returns true if the type defined in this string or the stored typealiases of it is a primitive type
    var isPrimitive: Bool {
        if let mappedType = TypeAliases.store[self] {
            return mappedType.isPrimitiveType
        }
        return isPrimitiveType
    }
    
    /// returns true if the type defined in this string is primitive and no collection
    var isPrimitiveAndNoCollection: Bool {
        !isCollectionType && isPrimitive 
    }
    
    /// removes a leading `_` from the string if one exists
    var removePrefix: String {
        self.first == "_" ? self.replacingOccurrences(of: "_", with: "") : self
    }
}
