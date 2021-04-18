//
//  Array+Convenience.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

extension Array where Element == String? {
    /// Joins all Strings in Array but skips empty values
    /// - Parameter separator: separator String
    /// - Returns: Joined String
    func skipEmptyJoined(separator: String = "") -> String {
        // Nil checked in previous statement
        // swiftlint:disable:next force_unwrapping
        self.filter { $0 != nil && !$0!.isEmpty }.map { $0! }.joined(separator: separator)
    }
}

extension Array where Element == AttributeModel {
    /// Sorts the array of AttributeModels and maps the `transform` operation
    /// - Parameter transform: method to be executed on each element of array
    /// - Returns: sorted & mapped array
    func sortedMap<T>(_ transform: (Element) -> T ) -> [T] {
        self.sorted(by: { $0.name < $1.name }).map(transform)
    }
}
