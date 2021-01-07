import Foundation

public struct HTTPAuthorization {

  public init(location: HTTPAuthorization.Location, key: String, value: String) {
    self.location = location
    self.key = key
    self.value = value
  }

  var location: Location
  var key: String
  var value: String

  public enum Location {
    case header
    case query
    case cookie
  }

}
