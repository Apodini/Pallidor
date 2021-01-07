import Combine
import Foundation

public struct StoreAPI {
  static let decoder: JSONDecoder = NetworkManager.decoder

  public static func deleteOrder(
    orderId: Int64, authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<String, Error> {

    return _StoreAPI.deleteOrder(
      orderId: orderId, authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  public static func getInventory(
    authorization: HTTPAuthorization = NetworkManager.authorization!,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<[String: Int32], Error> {

    return _StoreAPI.getInventory(authorization: authorization, contentType: contentType)
      .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  public static func getOrderById(
    orderId: Int64, authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<Order, Error> {

    return _StoreAPI.getOrderById(
      orderId: orderId, authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .map({ Order($0)! })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  public static func placeOrder(
    element: Order?, authorization: HTTPAuthorization? = NetworkManager.authorization,
    contentType: String? = NetworkManager.defaultContentType
  ) -> AnyPublisher<Order, Error> {

    return _StoreAPI.placeOrder(
      element: element?.to()!, authorization: authorization, contentType: contentType
    )
    .mapError({ (OpenAPIError($0 as? _OpenAPIError)!) })
    .map({ Order($0)! })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

}
