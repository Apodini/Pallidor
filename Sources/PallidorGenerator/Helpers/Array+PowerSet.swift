//
//  Array+PowerSet.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/** from: https://stackoverflow.com/questions/50264717/get-all-possible-combination-of-items-in-array-without-duplicate-groups-in-swift/50264766 */
extension Array {
    var powerSet: [[Element]] {
        guard !isEmpty else {
            return [[]]
        }
        return Array(self[1...]).powerSet.flatMap { [$0, [self[0]] + $0] }
    }
}
