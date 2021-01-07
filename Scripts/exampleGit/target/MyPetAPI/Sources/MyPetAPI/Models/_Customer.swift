import Foundation

class _Customer: Codable {

  //sourcery: isCustomType
  var address: [_Address]?
  var id: Int64?
  var username: String?

  init(address: [_Address]?, id: Int64?, username: String?) {

    self.address = address
    self.id = id
    self.username = username
  }

}
