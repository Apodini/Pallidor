import Foundation
import OpenAPIKit

/// Resolves dictionary types defined in open api document
enum DictionaryResolver {
    /// Resolve the type as String of the value types of a dictionary in a JSON Schema
     /// - Parameter schema: JSONSchema which needs to be checked
     /// - Returns: type as String
     static func resolveValueItem(schema: JSONSchema) -> String {
         switch schema {
         case .boolean:
             return "Bool"
         case .integer(let context, _):
             return PrimitiveTypeResolver.resolveTypeFormat(context: context)
         case .number(let context, _):
            return PrimitiveTypeResolver.resolveTypeFormat(context: context)
         case .string(let context, _):
             return PrimitiveTypeResolver.resolveTypeFormat(context: context)
         case .array(_, let arrayContext):
            guard let items = arrayContext.items else {
                fatalError("Array must contain at least one item.")
            }
            return "[\(ArrayResolver.resolveArrayItemType(schema: items))]"
         case .reference:
            guard let name = try? ReferenceResolver.resolveName(schema: schema) else {
                fatalError("Dictionary value types must have an identifier.")
            }
            return name
         default:
             return ""
         }
     }
}
