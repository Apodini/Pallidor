import Foundation

public class Customer: Codable {
  var address: [Address]?
  var id: Int64?
  var username: String?

  init(address: [Address]?, id: Int64?, username: String?) {
    self.address = address
    self.id = id
    self.username = username
  }

  init?(_ from: _Customer?) {
    if let from = from {

      self.address = from.address?.map({ Address($0)! })
      self.id = from.id
      self.username = from.username
    } else {
      return nil
    }
  }

  func to() -> _Customer? {

    return _Customer(address: self.address?.map({ $0.to()! }), id: self.id, username: self.username)
  }

}
