//
//  WrappedEnum.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

/// Wraps the enum type of Sourcery
class WrappedEnum: ModifiableFile {
    /// ModifiableFile protocol
    var id: String { localName }
    var fileName: String { localName }
    var modified: Bool = false
    var annotation: Annotation?
    
    /// contains additional imports besides Foundation if necessary
    var specialImports = Set<String>()
    
    /// true if stated in source code
    var ignore: Bool
    /// true if stated in source code
    var isOfType: Bool
    /// local name of enum
    var localName: String
    /// name of enum
    var name: String
    /// name of parent of enum (for internal enums)
    var parentName: String?
    /// list of inherited protocols
    var inheritedTypes: [String]
    /// list of enum cases
    var cases: [WrappedEnumCase]
    
    /// Default enum representation for internal enums
    lazy var defaultInternal : () -> String = {
        """
        public enum \(self.localName) : \(self.inheritedTypes.joined(separator: ", ")) {
            \(self.casesString)

            func to() -> \("\(self.parentName!).\(self.localName)")? {
                \("""
                \(
                    // is internal enum - always has parent.
                    // swiftlint:disable:next force_unwrapping
                    self.parentName!).\(self.localName)
                """)(rawValue : self.rawValue)
            }

            init?(_ from: \("""
        \(
            // is internal enum - always has parent.
            // swiftlint:disable:next force_unwrapping
            self.parentName!).\(self.localName)
        """)?) {
                if let from = from {
                    self.init(rawValue: from.rawValue)
                } else {
                    return nil
                }
            }

        }
        """
    }
    
    /// Default enum body  representation for external enums
    lazy var externalEnum : () -> String = {
               """
               \(self.casesString)

               func to() -> _\(self.localName)? {
                   _\(self.localName)(rawValue: self.rawValue)
               }

               init?(_ from: _\(self.localName)?) {
                   if let from = from {
                       self.init(rawValue: from.rawValue)
                   } else {
                       return nil
                   }
               }

               """
    }
    
    // MARK: - Initializers
    internal init(
        ignore: Bool,
        isOfType: Bool,
        localName: String,
        name: String,
        parentName: String? = nil,
        inheritedTypes: [String],
        cases: [WrappedEnumCase]
    ) {
        self.ignore = ignore
        self.isOfType = isOfType
        self.localName = localName
        self.name = name
        self.parentName = parentName
        self.inheritedTypes = inheritedTypes
        self.cases = cases
    }
    
    convenience init(from: Enum) {
        self.init(
            ignore: from.annotations["ignore"] != nil,
            isOfType: from.annotations["OfTypeEnum"] != nil,
            localName: from.localName.removePrefix,
            name: from.name,
            parentName: from.parentName,
            inheritedTypes: from.inheritedTypes,
            cases: from.cases.map { WrappedEnumCase(from: $0) }
        )
    }
    
    func modify(change: Change) {
        self.modified = true
        switch change.changeType {
        case .add:
            handleErrorEnumAddChange(change.typed(AddChange.self))
        case .replace:
            let change = change.typed(ReplaceChange.self)
            guard change.target == .signature else {
                fatalError("Target is not supported")
            }
            if case .model = change.object {
                handleReplacedParentChange(change: change)
            } else {
                handleReplacedChange(change: change)
            }
        case .rename:
            guard change.target == .signature else {
                fatalError("Target is not supported")
            }
            handleRenameChange(change: change.typed(RenameChange.self))
        case .delete:
            handleDeletedChange(change: change.typed(DeleteChange.self))
        default:
            fatalError("Enum: Change type not implemented") // TODO review
        }
    }
}

fileprivate extension WrappedEnum {
    func initEnumCase(_ targetCase: EnumModel.Case, _ caseType: String) -> WrappedEnumCase {
        WrappedEnumCase(
            name: targetCase.case,
            hasAssociatedValue: true,
            associatedValues: [
                WrappedAssociatedValue(
                    localName: "Int",
                    typeName: WrappedTypeName(
                        name: "Int",
                        actualName: "Int",
                        isOptional: false,
                        isArray: false,
                        isVoid: false,
                        isPrimitive: true
                    )),
                WrappedAssociatedValue(
                    typeName: WrappedTypeName(
                        name: caseType,
                        actualName: caseType,
                        isOptional: false,
                        isArray: caseType.isArrayType,
                        isVoid: false,
                        isPrimitive: caseType.isPrimitiveType
                    )
                )
            ])
    }
    
    func handleErrorEnumAddChange(_ change: AddChange) {
        if change.target == .case, self.localName == "OpenAPIError" {
            let cases = change.added.map { content -> EnumModel.Case in
                guard let enumCase = content as? EnumModel.Case else {
                    fatalError("Tried to add malformed enum case.")
                }
                return enumCase
            }
            self.cases.append(
                contentsOf: cases.map { targetCase -> WrappedEnumCase in
                    let caseType = targetCase.case
                        .replacingOccurrences(of: "response", with: "")
                        .replacingOccurrences(of: "Error", with: "")
                    return initEnumCase(targetCase, caseType)
                })
        }
    }
    
}
