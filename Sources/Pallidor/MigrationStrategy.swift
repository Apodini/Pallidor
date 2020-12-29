//
//  MigrationStrategy.swift
//  
//  Created by Andre Weinkoetz on 25.12.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import ArgumentParser

enum MigrationStrategy : String, ExpressibleByArgument {
    /// migrates all changes as stated in migration guide - `default`
    case all
    /// migrates no change. This is used for the first integration of the client library.
    case none
}
