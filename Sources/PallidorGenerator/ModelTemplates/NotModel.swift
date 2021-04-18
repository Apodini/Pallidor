//
//  NotModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// $not model as stated in open api document
struct NotModel: Schema {
    /// name of model
    var name: String
    /// type which this model can not be a type of
    var notOfType: String
    /// comment for this model
    var detail: String?
    
    var description: String {
            """
            import Foundation
            
            \(detail == nil ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                "" : "/** " + detail!.removeOAIIllegalCharacters() + " */\n")
            //sourcery: genericTypeAnnotation="<\(notOfType), T : Codable>"
            struct \(name)<\(notOfType), T : Codable> : Codable {
                let wrappedValue: T
                
                init(_ wrappedValue: T) {
                    assert(T.self != \(notOfType).self)
                    self.wrappedValue = wrappedValue
                }
                
                func encode(to encoder: Encoder) throws {
                    try wrappedValue.encode(to: encoder)
                }
                
                required init(from decoder: Decoder) throws {
                    self.wrappedValue = try T.init(from: decoder)
                }
                
            }
            """
    }
}
