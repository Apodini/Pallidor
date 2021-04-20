//
//  WrappedMethodParameter.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

/// Wrapped parameter of sourcery MethodParameter
class WrappedMethodParameter: Modifiable {
    var annotation: Annotation?

    var id: String {
        self.name
    }

    var modified: Bool = false

    func modify(change: Change) {
        self.modified = true
        switch change.changeType {
        case .add: handleAddChange(change.typed(AddChange.self))
        case .replace: handleReplacementChange(change.typed(ReplaceChange.self))
        case .rename: handleRenameChange(change.typed(RenameChange.self))
        case .delete: handleDeleteChange(change.typed(DeleteChange.self))
        case .nil: fatalError("Change type not supported for parameters.")
        }
    }

    internal init(
        name: String,
        isOptional: Bool,
        typeName: WrappedTypeName,
        actualTypeName: WrappedTypeName?,
        defaultValue: String?
    ) {
        self.name = name
        self.isOptional = isOptional
        self.typeName = typeName
        self.actualTypeName = actualTypeName
        self.defaultValue = defaultValue
    }

    convenience init(from: MethodParameter) {
        self.init(
            name: from.name,
            isOptional: from.isOptional,
            typeName: WrappedTypeName(from: from.typeName),
            actualTypeName: from.actualTypeName != nil ?
                // nil check before
                // swiftlint:disable:next force_unwrapping
                WrappedTypeName(from: from.actualTypeName!) :
                nil,
            defaultValue: from.defaultValue)
    }

    /// name of parameter
    var name: String
    /// true if parameter is optional
    var isOptional: Bool
    /// type of parameter
    var typeName: WrappedTypeName
    /// actual type of parameter (if type alias)
    var actualTypeName: WrappedTypeName?
    /// default value of parameter if available
    var defaultValue: String?
    /// true if default value is set
    var hasDefaultValue: Bool {
        defaultValue != nil
    }

    /// String representation of parameter in method signature
    lazy var signatureString : () -> String = { () in
        guard let actualTypeName = self.actualTypeName else {
            fatalError("Type missing for parameter: \(self.id)")
        }
        let isString = actualTypeName.name.unwrapped.isString && self.id != "contentType"
        let defaultValue = """
\(self.hasDefaultValue ?
    """
 = \(isString ? // swiftlint:disable:next force_unwrapping
        "\"\(self.defaultValue!.replacingOccurrences(of: "\"", with: "") )\"" : // swiftlint:disable:next force_unwrapping
        "\(self.defaultValue!)")
""" : "")
"""
        return "\(self.name): \(actualTypeName.name) \(defaultValue)"
    }

    /// String for parameter conversion
    lazy var paramConversionString : () -> String = { () in "" }

    /// String representation of parameter in calling the api method
    lazy var endpointCall : () -> String = {
        let isPrimitive = self.name != "element" || self.typeName.name.isPrimitiveType

        guard !isPrimitive else {
            return "\(self.name): \(self.name)"
        }

        let optional = self.isOptional ? "?" : ""

        return self.name == "element" && self.typeName.isArray ?
            "element: element\(optional).map({$0.to()!})" :
            (self.name == "element" ?
                "element: element\(optional).to()!" :
                "\(self.name): \(self.name)")
    }
}
