//
//  Schema.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Schema protocol which all component schema models must conform to
protocol Schema: CustomStringConvertible {
    /// name of schema
    var name: String { get set }
    /// comment of schema
    var detail: String? { get set }
}
