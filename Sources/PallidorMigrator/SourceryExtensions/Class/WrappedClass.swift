//
//  WrappedClass.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

/// Wraps class type of Sourcery
class WrappedClass: ModifiableFile {
    /// ModifiableFile protocol
    var id: String { localName }
    var modified: Bool = false
    var annotation: Annotation?
    var fileName: String { localName }

    internal init(
        inheritedTypes: [String],
        localName: String,
        genericAnnotation: String,
        isGeneric: Bool,
        variables: [WrappedVariable],
        methods: [WrappedMethod]
    ) {
        self.inheritedTypes = inheritedTypes
        self.localName = localName
        self.isGeneric = isGeneric
        self.variables = variables
        self.methods = methods
        self.genericAnnotation = genericAnnotation
    }

    convenience init(from: SourceryRuntime.Class) {
        self.init(
            inheritedTypes: from.inheritedTypes,
            localName: from.localName.removePrefix,
            genericAnnotation: from.annotations["genericTypeAnnotation"] as? String ?? "<T: Codable>",
            isGeneric: from.isGeneric,
            variables: from.variables.map { WrappedVariable(from: $0) },
            methods: from.methods.map { WrappedMethod(from: $0) }
        )
    }

    /// protocols implemented
    var inheritedTypes: [String]
    /// name of class
    var localName: String
    /// annotation if class is generic
    var genericAnnotation: String
    /// true if class is generic
    var isGeneric: Bool
    /// variables of class
    var variables: [WrappedVariable]
    /// methods of class
    var methods: [WrappedMethod]
    /// contains additional imports besides Foundation if necessary
    var specialImports = Set<String>()

    /// initializer string
    lazy var initializer: () -> String = { () in
        """
        init(\(self.variables
                .filter { $0.isMutable }
                .sorted(by: { $0.name < $1.name })
                .map { $0.initParam() }
                .skipEmptyJoined(separator: ", "))){
        \(self.variables
            .filter { $0.isMutable }
            .sorted(by: { $0.name < $1.name })
            .map { $0.initBody() }
            .skipEmptyJoined(separator: "\n"))
        }
        """
    }

    /// `from()` string for facade type conversion
    lazy var facadeFrom : () -> String = { () in
        """
        init?(_ from : _\(self.localName)?) {
            if let from = from {
        \(self.replacedProperty ?
            """
            let context = JSContext()!
            \(self.variables.map { $0.replaceAdaption(true) }.skipEmptyJoined(separator: ", "))
            """
        : "")
            \(self.variables.map { $0.convertFrom() }.joined(separator: "\n"))
            } else {
            return nil
            }
        }
        """
    }

    /// `to()` string for facade type conversion
    lazy var facadeTo : () -> String = { () in
        """
        func to() -> _\(self.localName)? {
        \(self.replacedProperty ?
        """
        let context = JSContext()!
        \(self.variables.map { $0.replaceAdaption(false) }.skipEmptyJoined(separator: ", "))
        """
        : "")
        return _\(self.localName)(\(self.variables
                                        .sorted(by: { $0.name < $1.name })
                                        .map { $0.convertTo() }
                                        .skipEmptyJoined(separator: ", ")))
        }
        """
    }
    
    var replacedProperty = false
    /// list of enums inside this class
    var nestedEnums: [WrappedEnum]?

    func accept(change: Change) {
        modified = true
        switch change.changeType {
        case .add: handleAddedProperty(change.typed(AddChange.self))
        case .delete: handleDeleted(change.typed(DeleteChange.self))
        case .replace: handleReplaced(change.typed(ReplaceChange.self))
        case .rename: handleRenamed(change.typed(RenameChange.self))
        case .nil: fatalError("No change type detected.")
        }
    }

    fileprivate func handleDeleted(_ change: DeleteChange) {
        if case .property = change.target {
            handleDeletedProperty(change)
        }
        if case .signature = change.target {
            handleDeletedChange(change)
        }
        if case .case = change.target {
            handleDeletedOfType(change)
        }
    }

    fileprivate func handleReplaced(_ change: ReplaceChange) {
        if change.target == .property {
            self.replacedProperty = true
            handleReplacedProperty(change)
        }
        if change.target == .signature {
            handleReplacedChange(change)
        }
    }

    fileprivate func handleRenamed(_ change: RenameChange) {
        if case .property = change.target {
            handleRenameProperty(change)
        }
        if case .signature = change.target {
            handleRenameChange(change)
        }
    }
}
