//
//  ObjectModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

class ObjectModel: Schema {
    /// comment for this model
    var detail: String?
    /// true if model is generic
    var isGeneric: Bool = false
    
    var description: String {
            """
            import Foundation
            
            \(detail == nil ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                "" : "/** " + detail!.removeOAIIllegalCharacters() + " */\n")
            
            class _\(name)\(isGeneric ? "<T: Codable>" : ""): Codable {
            
            \(attributes.sortedMap { $0.alterIllegalName(objectName: name).description }.joined())
            
            init(\(attributes.sortedMap { $0.getInitParamString() }.joined().dropLast(2))) {
            
                    \(attributes.sortedMap { $0.getInitializerString() }.joined(separator: "\n"))
                }
                
            }
            
            """
    }
    
    /// name of model
    var name: String
    /// attributes for this model
    var attributes: [AttributeModel]
    
    init(name: String, attributes: [AttributeModel], detail: String?) {
        self.name = name.normalized
        self.attributes = attributes
        self.detail = detail
    }
}
