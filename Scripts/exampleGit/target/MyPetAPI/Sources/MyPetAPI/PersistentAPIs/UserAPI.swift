import Combine
import Foundation

public struct UserAPI {
  static let decoder: JSONDecoder = NetworkManager.decoder

  public static func createUser(
    element: User?, authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<User, Error> {

    return _UserAPI.createUser(
      element: element?.to()!, authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .map({ User($0)! })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  public static func createUsersWithListInput(
    element: [User]?, authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<User, Error> {

    return _UserAPI.createUsersWithListInput(
      element: element?.map({ $0.to()! }), authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .map({ User($0)! })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  public static func deleteUser(
    username: String, authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<String, Error> {

    return _UserAPI.deleteUser(
      username: username, authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  public static func getUserByName(
    username: String, authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<User, Error> {

    return _UserAPI.getUserByName(
      username: username, authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .map({ User($0)! })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  public static func loginUser(
    password: String?, username: String?,
    authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<String, Error> {

    return _UserAPI.loginUser(
      password: password, username: username, authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  public static func logoutUser(
    authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<String, Error> {

    return _UserAPI.logoutUser(authorization: authorization, contentType: contentType)
      .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  public static func updateUser(
    username: String, element: User?,
    authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<String, Error> {

    return _UserAPI.updateUser(
      username: username, element: element?.to()!, authorization: authorization,
      contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

}
