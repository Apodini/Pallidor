//
//  WrappedStruct.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

/// Wraps struct types of Sourcery
class WrappedStruct: ModifiableFile {
    /// ModifiableFile protocol
    var annotation: Annotation?
    var id: String {
        "/\(localName.replacingOccurrences(of: "API", with: "").replacingOccurrences(of: "_", with: "").lowercased())"
    }

    var modified: Bool = false
    var fileName: String { localName.removePrefix }

    /// contains additional imports besides Foundation if necessary
    var specialImports = Set<String>()
    /// name of struct
    var localName: String
    /// variables of struct
    var variables: [WrappedVariable]
    /// methods of struct
    var methods: [WrappedMethod]
    
    // MARK: - Initializers
    internal init(localName: String, variables: [WrappedVariable], methods: [WrappedMethod]) {
        self.localName = localName
        self.variables = variables
        self.methods = methods
    }

    convenience init(from: SourceryRuntime.Struct) {
        self.init(
            localName: from.localName.removePrefix,
            variables: from.variables.map { WrappedVariable(from: $0) },
            methods: from.methods.map { WrappedMethod(from: $0) }
        )
    }
}

extension WrappedStruct {
    func modify(change: Change) {
        self.modified = true

        switch change.changeType {
        case .replace:
            specialImports.insert("import JavaScriptCore")
        case .rename:
            let change = change.typed(RenameChange.self)
            if case .signature = change.target, case .endpoint = change.object {
                handleEndpointRenameChange(change)
            }
        case .delete:
            let change = change.typed(DeleteChange.self)
            if case .signature = change.target, case .endpoint = change.object {
                handleEndpointDeletedChange(change)
            }
        default:
            guard case .method = change.object else {
                fatalError("Change type not supported on target endpoint.")
            }
        }

        delegateChangeToMethods(change)
    }

    fileprivate func delegateChangeToMethods(_ change: Change) {
        for method in methods {
            if case .method(let target) = change.object, target.operationId == method.id {
                method.modify(change: change)
            }
        }
    }
}

extension WrappedStruct: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        WrappedStruct(localName: localName, variables: variables, methods: methods)
    }
}
