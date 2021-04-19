//
//  TypeName+CustomType.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryRuntime

extension WrappedTypeName {
    /// maps the publisher success type from api to facade type
    var mappedPublisherType: String {
        let unmappedType = name
            .replacingOccurrences(
                of: "AnyPublisher<",
                with: ""
            )
            .replacingOccurrences(of: ", Error>", with: "")
        return "AnyPublisher<\(unmappedType.replacingOccurrences(of: "_", with: "").unwrapped), Error>"
    }

    /// success type without `AnyPublisher` wrapper
    var mappedPublisherSuccessType: String {
        mappedPublisherType
            .replacingOccurrences(
                of: "AnyPublisher<",
                with: ""
            )
            .replacingOccurrences(of: ", Error>", with: "")
    }

    /// removes optional and collection characters from array type name
    var arrayElementType: String {
        name.withoutSquareBrackets
    }
    
    /// returns the string of the value type of a dictionary
    var dictionaryValueType: String {
        let types = String(name.withoutSquareBrackets).split(separator: ":")
        
        if let valueType = types.last {
            return String(valueType).unwrapped
        }
        return name
        
    }

}
