//
//  ModelError.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Errors which can occur during converting open api document
enum ResolvementError: Error {
    case nestedObjectError(msg: String)
    case unknownType(msg: String)
    case notSupported(msg: String)
    case referenceTypeNotFound(msg: String)
}
