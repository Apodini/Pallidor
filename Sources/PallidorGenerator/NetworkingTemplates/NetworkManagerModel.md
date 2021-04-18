            import Foundation
            import Combine


            // MARK: NetworkManager
            /// A `NetworkManager` handles the HTTP based network Requests to a server
            public enum NetworkManager {
                
            public static var servers: [String] {
                get { ###PLACEHOLDER### }
            }
            
                public static var basePath: String? = servers.first
                
                /// The `AnyCancellable`s that are used to track network requests made by the `NetworkManager`
                public static var cancellables: Set<AnyCancellable> = []
                /// The default `Authorization` header field for requests made by the `NetworkManager`
                public static var authorization: HTTPAuthorization?
                
                public static var defaultContentType: String? = "application/json"
                
                public static var customDateFormatter : DateFormatter?
                
                /// The `JSONEncoder` that is used to encode request bodies to JSON
                static var encoder: JSONEncoder = {
                    let encoder = JSONEncoder()
                   
                    if let customDateFormatter = NetworkManager.customDateFormatter {
                        encoder.dateEncodingStrategy = .formatted(customDateFormatter)
                    } else {
                        encoder.dateEncodingStrategy = .iso8601
                    }
                    return encoder
                }()
                
                /// The `JSONDecoder` that is used to decode response bodies to JSON
                static var decoder: JSONDecoder = {
                    let decoder = JSONDecoder()
                    if let customDateFormatter = NetworkManager.customDateFormatter {
                        decoder.dateDecodingStrategy = .formatted(customDateFormatter)
                    } else {
                        decoder.dateDecodingStrategy = .iso8601
                    }
                    return decoder
                }()
                
                
                /// Creates a `URLRequest` based on the parameters that has the `Content-Type` header field set to `application/json`
                /// - Parameters:
                ///   - method: The HTTP method
                ///   - url: The `URL` of the `URLRequest`
                ///   - authorization: The value that should be added the `Authorization` header field
                ///   - body: The HTTP body that should be added to the `URLRequest`
                /// - Returns: The created `URLRequest`
                static func urlRequest(_ method: String,
                                       url: URL,
                                       authorization: HTTPAuthorization? = nil,
                                       contentType: String? = defaultContentType,
                                       headers: [String: String]? = nil,
                                       body: Data? = nil) -> URLRequest {
                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = method
                    
                    if let contentType = contentType {
                        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
                    } else {
                        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
            
                    if let headers = headers {
                        for (key, value) in headers {
                            urlRequest.addValue(value, forHTTPHeaderField: key)
                        }
                    }
                    
                    if let authorization = authorization {
                        switch authorization.location {
                        case .cookie:
                            urlRequest.addValue(authorization.value, forHTTPHeaderField: authorization.key)
                            break
                        case .header:
                            urlRequest.addValue(authorization.value, forHTTPHeaderField: authorization.key)
                            break
                        case .query:
                            if url.query != nil {
                                urlRequest.url!.appendPathComponent("&\\(authorization.key)=\\(authorization.value)")
                            } else {
                                urlRequest.url!.appendPathComponent("?\\(authorization.key)=\\(authorization.value)")
                            }
                        }
                    }
                    
                    urlRequest.httpBody = body
                    
                    return urlRequest
                }
                
                
                /// Gets a single `Element` from a `URL` specified by `route`
                /// - Parameters:
                ///     - route: The route to get the `Element` from
                ///     - authorization: The `String` that should written in the `Authorization` header field
                /// - Returns: An `AnyPublisher` that contains the `Element` from the server or or an `Error` in the case of an error
                static func getElement(on route: URL,
                                       authorization: HTTPAuthorization? = authorization,
                                       contentType: String? = defaultContentType,
                                        headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                    URLSession.shared.dataTaskPublisher(for:
                        urlRequest("GET", url: route, authorization: authorization, contentType: contentType, headers: headers)
                    )
                }
                
                /// Creates an `Element`s to a `URL` specified by `route`
                /// - Parameters:
                ///     - element: The `Element` that should be created
                ///     - route: The route to get the `Element`s from
                ///     - authorization: The `String` that should written in the `Authorization` header field
                /// - Returns: An `AnyPublisher` that contains the created `Element` from the server or an `Error` in the case of an error
                static func postElement<Element: Codable>(_ element: Element?,
                                                    authorization: HTTPAuthorization? = authorization,
                                                    on route: URL,
                                                    contentType: String? = defaultContentType,
                                                    headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                    URLSession.shared.dataTaskPublisher(for:
                            urlRequest("POST", url: route, authorization: authorization, contentType: contentType, headers: headers, body: try? encoder.encode(element))
                    )
                }
                
                static func postElement(authorization: HTTPAuthorization? = authorization,
                                        on route: URL,
                                        contentType: String? = defaultContentType,
                                        headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                    URLSession.shared.dataTaskPublisher(for:
                        urlRequest("POST", url: route, authorization: authorization, contentType: contentType, headers: headers)
                    )
                }
                
                /// Updates an `Element`s to a `URL` specified by `route`
                /// - Parameters:
                ///     - element: The `Element` that should be updated
                ///     - route: The route to get the `Element`s from
                ///     - authorization: The `String` that should written in the `Authorization` header field
                /// - Returns: An `AnyPublisher` that contains the updated `Element` from the server or an `Error` in the case of an error
                static func putElement<Element: Codable>(_ element: Element,
                                                   authorization: HTTPAuthorization? = authorization,
                                                   on route: URL,
                                                   contentType: String? = defaultContentType,
                                                   headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                    URLSession.shared.dataTaskPublisher(for:
                            urlRequest("PUT", url: route, authorization: authorization, contentType: contentType, headers: headers, body: try? encoder.encode(element))
                        )
                }
                
                static func putElement(authorization: HTTPAuthorization? = authorization,
                                       on route: URL,
                                       contentType: String? = defaultContentType,
                                       headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                    URLSession.shared.dataTaskPublisher(for:
                        urlRequest("PUT", url: route, authorization: authorization, contentType: contentType, headers: headers)
                    )
                }
                
                /// Deletes a Resource identifed by an `URL` specified by `route`
                /// - Parameters:
                ///     - route: The route that identifes the resource
                ///     - authorization: The `String` that should written in the `Authorization` header field
                /// - Returns: An `AnyPublisher` that contains indicates of the deletion was successful
                static func delete(at route: URL,
                                   authorization: HTTPAuthorization? = authorization, contentType: String? = defaultContentType, headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                    URLSession.shared.dataTaskPublisher(for:
                            urlRequest("DELETE", url: route, authorization: authorization, contentType: contentType, headers: headers)
                        )
                }
            
            
                /// Updates an `Element`s to a `URL` specified by `route`
                   /// - Parameters:
                   ///     - element: The `Element` that should be created
                   ///     - route: The route to get the `Element`s from
                   ///     - authorization: The `String` that should written in the `Authorization` header field
                   /// - Returns: An `AnyPublisher` that contains the created `Element` from the server or an `Error` in the case of an error
                   static func patchElement<Element: Codable>(_ element: Element?,
                                                       authorization: HTTPAuthorization? = authorization,
                                                       on route: URL,
                                                       contentType: String? = defaultContentType, headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                       URLSession.shared.dataTaskPublisher(for:
                               urlRequest("PATCH", url: route, authorization: authorization, contentType: contentType, headers: headers, body: try? encoder.encode(element))
                       )
                   }
                   
                   static func patchElement(authorization: HTTPAuthorization? = authorization,
                                           on route: URL,
                                           contentType: String? = defaultContentType, headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                       URLSession.shared.dataTaskPublisher(for:
                           urlRequest("PATCH", url: route, authorization: authorization, contentType: contentType, headers: headers)
                       )
                   }
            
            
                  static func trace(authorization: HTTPAuthorization? = authorization,
                                          on route: URL,
                                          contentType: String? = defaultContentType, headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                      URLSession.shared.dataTaskPublisher(for:
                          urlRequest("TRACE", url: route, authorization: authorization, contentType: contentType, headers: headers)
                      )
                  }
            
                  static func head(authorization: HTTPAuthorization? = authorization,
                                            on route: URL,
                                            contentType: String? = defaultContentType, headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                        URLSession.shared.dataTaskPublisher(for:
                            urlRequest("HEAD", url: route, authorization: authorization, contentType: contentType, headers: headers)
                        )
                  }
            
                  static func options(authorization: HTTPAuthorization? = authorization,
                                    on route: URL,
                                    contentType: String? = defaultContentType, headers: [String: String]? = nil) -> URLSession.DataTaskPublisher {
                        URLSession.shared.dataTaskPublisher(for:
                            urlRequest("OPTIONS", url: route, authorization: authorization, contentType: contentType, headers: headers)
                        )
                  }
            
            
                
            }
