import Foundation

enum _OpenAPIError : Error {

case responseUserError(Int, _User)
    case urlError(URLError)
}

// sourcery:begin: ignore
enum APIEncodingError: Error {
    case canNotEncodeOfType(Codable.Type)
}
// sourcery:end
