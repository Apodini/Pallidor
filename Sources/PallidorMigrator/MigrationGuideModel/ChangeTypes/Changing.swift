//
//  Changing.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Protocol all change types have to conform to
protocol Changing: Decodable {
    /// optional reason of change if stated in migration guide
    var reason: String? { get set }

    /// changed object (e.g. model, endpoint, method)
    var object: ObjectType { get set }

    /// change target (e.g. signature, parameter, etc.)
    var target: TargetType { get set }

    /// type of change (DELETED, ADDED, etc.)
    var changeType: ChangeType { get set }

    /// validation method to determine if change can be executed
    func validate() throws
}

extension Changing {
    /// Used to cast to a certain change type
    /// - Parameter type: Type of change
    /// - Note: Results in a fatal error if `self` casting to `C` fails.
    /// Throughout the project used safely after ensurance of the respective `changeType` property
    func typed<C: Changing>(_ type: C.Type) -> C {
        guard let typed = self as? C else {
            fatalError("Change \(C.self) is malformed")
        }
        return typed
    }
}
