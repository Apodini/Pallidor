//
//  SchemaConverter.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit
import PathKit

/// Converter: Takes the parsed OpenAPI document (from OpenAPIKit) and creates Model objects. These objects contain the template to be exported as a Swift file.
public struct SchemaConverter: Converting {
    var resolvedDocument: ResolvedDocument
    
    /// Content of this converter
    var schemas: [Schema] = [Schema]()
    
    private var objects = [ObjectModel]()
    private var notOfModels = [NotModel]()
    private var enums = [EnumModel]()
    
    init(_ resolvedDocument: ResolvedDocument) {
        self.resolvedDocument = resolvedDocument
        ReferenceResolver.components = resolvedDocument.components
    }
    
    mutating func writeToFile(path outputPath: Path) throws -> [URL] {
        var filePaths = [URL]()
        
        for schema in schemas {
            let fileName = outputPath + Path("_\(schema.name).swift")
            try schema.description.write(to: fileName.url, atomically: true, encoding: .utf8)
            filePaths.append(fileName.url)
        }
        
        return filePaths
    }
    
    
    /// Returns the schema by its identification
    /// - Parameter name: name of schema
    /// - Returns: schema object
    func getSchema(name: String) -> Schema? {
        // nil checked
        // swiftlint:disable:next force_unwrapping
        schemas.first(where: { $0 != nil && $0!.name == name })
    }
    
    mutating func parse() {
        parseEnumModels()
        parseObjectModels()
        
        NotOfResolver.resolveReferenced(objects: objects)
        
        schemas.append(contentsOf: objects)
        schemas.append(contentsOf: enums)
        schemas.append(contentsOf: notOfModels)
        
        var combinations = Set<String>()
        
        for schemaModel in schemas {
            if let ofModel = schemaModel as? OfModel, ofModel.typeOf == .anyOf {
                combinations = combinations.union(Array(ofModel.inheritedObjects))
            }
        }
        
        var sortedCombinations = [ObjectModel]()
        
        for name in combinations.sorted(by: { $0 < $1 }) {
            if let objectModel = schemas
                .first(where: { $0.name == name.replacingOccurrences(of: "_", with: "") })
                as? ObjectModel {
                sortedCombinations.append(objectModel)
            }
        }
        
        let combinedObjects = sortedCombinations.powerSet.filter { $0.count > 1 }
        
        let toAdd = combinedObjects.map { models -> ObjectModel in
            let sorted = models.sorted(by: { $0.name < $1.name })
            let name = sorted.map { $0.name }.joined()
               
            let attributes = sorted.reduce(into: []) { attributes, model in
                attributes.append(contentsOf: model.attributes)
            }

            return ObjectModel(name: name, attributes: attributes, detail: "Auto generated for AnyOf Codable")
        }
        
        schemas.append(contentsOf: toAdd)
    }
    
    private mutating func parseObjectModels() {
        for (name, schema) in resolvedDocument.components.schemas {
            var object: ObjectModel?
            if case .object(let general, let objectContext) = schema {
                object = ObjectResolver.resolve(name: name.rawValue, context: general, schema: objectContext)
            }
            
            if case .all(of: let schemas, core: _) = schema {
                object = AllOfResolver.resolve(objectName: name.rawValue, schemas: schemas)
            }
            
            if case .one(of: let schemas, core: _) = schema {
                object = OneOfResolver.resolve(objectName: name.rawValue, schemas: schemas)
            }
            
            if case .not(let schema, core: _) = schema {
                if let notOfModel = try? NotOfResolver.resolve(objectName: name.rawValue, schema: schema) {
                    notOfModels.append(notOfModel)
                }
            }
            if case .any(of: let schemas, core: _) = schema {
                object = AnyOfResolver.resolve(objectName: name.rawValue, schemas: schemas)
            }
            if let object = object {
                objects.append(object)
            }
        }
    }
    
    private mutating func parseEnumModels() {
        for (name, schema) in resolvedDocument.components.schemas {
            var enumModel: EnumModel?
            
            guard let allowedValues = schema.allowedValues else {
                continue
            }
            
            switch schema {
            case .integer(let generalContext, _):
                enumModel = EnumModel(
                    name: name.rawValue,
                    enumValues: allowedValues.map({ value -> String in
                        value.value as! String // swiftlint:disable:this force_cast
                    }),
                    enumType: generalContext.format.rawValue.isEmpty ?
                        "Int" :
                        generalContext.format.rawValue.capitalized,
                    detail: generalContext.description
                )
            case .number(let generalContext, _):
                enumModel = EnumModel(
                    name: name.rawValue,
                    enumValues: allowedValues.map({ value -> String in
                        value.value as! String // swiftlint:disable:this force_cast
                    }),
                    enumType: generalContext.format.rawValue.isEmpty ?
                        "Double" :
                        generalContext.format.rawValue.capitalized,
                    detail: generalContext.description
                )
            case .string(let generalContext, _):
                enumModel = EnumModel(
                    name: name.rawValue,
                    enumValues:
                        allowedValues.map({ value -> String in
                            value.value as! String // swiftlint:disable:this force_cast
                        }),
                    enumType: "String",
                    detail: generalContext.description
                )
            default:
                break
            }
            
            if let enumModel = enumModel {
                enums.append(enumModel)
            }
        }
    }
}
