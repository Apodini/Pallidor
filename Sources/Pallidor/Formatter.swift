//
//  Formatter.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SwiftFormat
import SwiftFormatConfiguration

/// responsible for code formatting
/// uses `SwiftFormatter` either with a provided or a default configuration
struct Formatter {
    /// SwiftFormatter
    var formatter: SwiftFormatter
     
    /// Initializes Formatter
    init(configPath path: String? = nil) throws {
        if let path = path {
            let config = try Configuration(contentsOf: URL(fileURLWithPath: path))
            self.formatter = SwiftFormatter(configuration: config)
        } else {
            let defaultConfig = Configuration()
            self.formatter = SwiftFormatter(configuration: defaultConfig)
        }
    }
    
    
    /// Formats code of files in `[URL]`
    /// - Parameter paths: fileURLs as `[URL]`
    /// - Throws: error if formatting or writing fails
    func format(paths: [URL]) throws {
        for path in paths {
            var output = ""

            try formatter.format(contentsOf: path, to: &output)

            try output.write(to: path, atomically: true, encoding: .utf8)
        }
    }
}
