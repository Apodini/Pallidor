//
//  WrappedMethod.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

/// Wrapped method of sourcery Method
class WrappedMethod: Modifiable {
    var annotation: Annotation?

    var id: String { self.shortName }

    var modified: Bool = false

    /// true if a parameter was replaced by a different type
    var paramsRequireJSContext = false

    func modify(change: Change) {
        self.modified = true

        switch change.changeType {
        case .add:
            guard let change = change as? AddChange else {
                fatalError("Change is malformed: AddChange")
            }
            handleAddChange(change: change)
        case .rename:
            guard let change = change as? RenameChange else {
                fatalError("Change is malformed: RenameChange")
            }
            handleRenameChange(change: change)
        case .replace:
            guard let change = change as? ReplaceChange else {
                fatalError("Change is malformed: ReplaceChange")
            }
            handleReplaceChange(change: change)
        case .delete:
            guard let change = change as? DeleteChange else {
                fatalError("Change is malformed: DeleteChange")
            }
            handleDeleteChange(change: change)
        case .nil:
            fatalError("Change type malformed.")
        }
    }

    internal init(
        ignore: Bool,
        isInitializer: Bool,
        isRequired: Bool,
        isGeneric: Bool,
        isStatic: Bool,
        throws: Bool,
        name: String,
        definedInTypeName: WrappedTypeName? = nil,
        returnTypeName: WrappedTypeName,
        parameters: [WrappedMethodParameter]
    ) {
        self.ignore = ignore
        self.isInitializer = isInitializer
        self.isRequired = isRequired
        self.isGeneric = isGeneric
        self.isStatic = isStatic
        self.`throws` = `throws`
        self.name = name
        self.definedInTypeName = definedInTypeName
        self.returnTypeName = returnTypeName
        self.parameters = parameters
    }

    convenience init(from: SourceryMethod) {
        self.init(
            ignore: from.annotations["ignore"] != nil,
            isInitializer: from.isInitializer,
            isRequired: from.isRequired,
            isGeneric: from.isGeneric,
            isStatic: from.isStatic,
            throws: from.throws,
            name: from.name,
            definedInTypeName: from.definedInTypeName != nil ?
                // nil check in previous line
                // swiftlint:disable:next force_unwrapping
                WrappedTypeName(from: from.definedInTypeName!) : nil,
            returnTypeName: WrappedTypeName(from: from.returnTypeName),
            parameters: from.parameters.map { WrappedMethodParameter(from: $0) }
        )
    }

    var ignore: Bool
    var isInitializer: Bool
    var isRequired: Bool
    var isGeneric: Bool
    var isStatic: Bool
    var `throws`: Bool
    var name: String
    var definedInTypeName: WrappedTypeName?
    var returnTypeName: WrappedTypeName
    var parameters: [WrappedMethodParameter]

    var getPersistentInitializer: (WrappedMethod) -> String = { method in method.name }

    lazy var nameToCall : () -> String = { () in
        self.shortName
    }

    lazy var apiMethodString : () -> String = { () in
        """
        \(self.signatureString) {
        \(self.parameterConversion() ?? "")
        return _\(
            // it's a method that must be specified in a parent component.
            // swiftlint:disable:next force_unwrapping
            self.definedInTypeName!.name).\(self.nameToCall())(\(
            self.parameters.map { $0.endpointCall() }.skipEmptyJoined(separator: ", ")))
        \(self.apiMethodResultMap)
        }
        """
    }

    lazy var parameterConversion : () -> String? = {
        self.paramsRequireJSContext ?
            """
            let context = JSContext()!
            \(self.parameters.map { $0.paramConversionString() }.skipEmptyJoined(separator: "\n"))
            """
            : self.parameters.map { $0.paramConversionString() }.skipEmptyJoined(separator: "\n")
    }

    lazy var parameterString : () -> String = { () in
        self.parameters.compactMap { $0.signatureString() }.skipEmptyJoined(separator: ", ")
    }

    lazy var mapString: (String) -> String? = { type in
        type.isPrimitiveType ? nil :
            ( type.isArrayType ?
                """
                .map({$0.map({\(type.dropFirstAndLast())($0)!})})
                """
                :
                """
                .map({\(type)($0)!})
                """
            )
    }
}
