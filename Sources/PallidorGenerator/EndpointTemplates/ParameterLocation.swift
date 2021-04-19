import OpenAPIKit

/// Possible location of parameters
enum ParameterLocation: Equatable {
    case path(String)
    case query(String)
    case header(String)  /** not "Accept", "Content-Type" or "Authorization" */
    case cookie(String)
    
    init(parameter: DereferencedParameter) {
        let parameterName = parameter.name
        switch parameter.location {
        case .cookie: self = .cookie(parameterName)
        case .header: self = .header(parameterName)
        case .query: self = .query(parameterName)
        case .path: self = .path(parameterName)
        }
    }
}
