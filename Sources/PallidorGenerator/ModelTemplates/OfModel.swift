//
//  OfModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// $anyOf or $oneOf models as stated in open api document
class OfModel: ObjectModel {
    override var description: String {
            """
            import Foundation
            
            class _\(name)\(isGeneric ? "<T: Codable>" : ""): Codable {
            
                //sourcery: isCustomInternalEnumType
                var of: \(typeOf.rawValue)
            
                //sourcery: OfTypeEnum
                enum \(typeOf.rawValue) : Codable {
            
                \(inheritedObjects.map { "case \($0.caseLowerFirst())(\(getInheritedObjectType(from: $0)))"
                }
                .joined(separator: "\n"))
                \(combinedObjects.map { "case \($0.caseLowerFirst())(\(getInheritedObjectType(from: $0)))"
                }
                .joined(separator: "\n"))
            
                    //sourcery: ignore
                    func encode(to encoder: Encoder) throws {
                        switch self {
                            \(inheritedObjects.map { """
                            case .\($0.caseLowerFirst())(let of):
                                try of.encode(to: encoder)
                                break
                            """
                            }
                            .joined(separator: "\n"))
                            \(combinedObjects.map { """
                            case .\($0.caseLowerFirst())(let of):
                                try of.encode(to: encoder)
                                break
                            """
                            }
                            .joined(separator: "\n"))
                        }
                    }
            
                    //sourcery: ignore
                    init(from decoder: Decoder) throws {
                        \(inheritedObjects.map {
                        """
                        if let \($0.caseLowerFirst()) = try? \(getInheritedObjectType(from: $0)).init(from: decoder) {
                        self = .\($0.caseLowerFirst())(\($0.caseLowerFirst()))
                        return
                        }
                        """
                        }
                        .joined(separator: "\n"))
                        \(combinedObjects.map {
                        """
                        if let \($0.caseLowerFirst()) = try? \(getInheritedObjectType(from: $0)).init(from: decoder) {
                            self = .\($0.caseLowerFirst())(\($0.caseLowerFirst()))
                                return
                        }
                        """
                        }
                        .joined(separator: "\n"))
            
                        throw APIEncodingError.canNotEncodeOfType(_\(name).self)
                    }
                    
                }
            
                init(of: \(typeOf.rawValue)){
                    self.of = of
                }
            
                //sourcery: ignore
                func encode(to encoder: Encoder) throws {
                    try of.encode(to: encoder)
                }
            
                //sourcery: ignore
                required init(from decoder: Decoder) throws {
                    self.of = try \(typeOf.rawValue).init(from: decoder)
                }
            
            }

            """
    }

    /// list of objects which are part of $of model
    var inheritedObjects: [String]
    
    /// combination objects (combines model types for $anyOf operator)
    var combinedObjects: [String] {
            typeOf == .anyOf
                ? inheritedObjects.powerSet
                    .filter { $0.count > 1 }
                    .map { "_\($0.sorted(by: { $0 < $1 }).joined().replacingOccurrences(of: "_", with: ""))" }
                    .sorted(by: { $0 < $1 })
                : []
    }
    
    /// anyOf or oneOf type
    var typeOf: TypeOf
    
    /// type of $of
    enum TypeOf: String {
        case oneOf = "OneOf"
        case anyOf = "AnyOf"
    }

    init(name: String, detail: String? = nil, typeOf: OfModel.TypeOf, inheritedObjects: [String]) {
        self.typeOf = typeOf
        self.inheritedObjects = inheritedObjects
        super.init(name: name, attributes: [], detail: detail)
    }
}

extension OfModel {
    /// Renames case types
    /// - Parameter name: name of type
    /// - Returns: renamed type
    private func getInheritedObjectType(from name: String) -> String {
        if NotOfResolver.notOfReferred.contains(name) {
            return "\(name)<T>"
        }
        
        if NotOfResolver.notOfReferences.contains(name) {
            return "\(name)<\(name[name.index(name.startIndex, offsetBy: 3)...]), T>"
        }
        
        return name.contains("_") ? name : "_\(name)"
    }
}
