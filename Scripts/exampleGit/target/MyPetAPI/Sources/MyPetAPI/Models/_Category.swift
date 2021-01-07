import Foundation

class _Category: Codable {

  var id: Int64?
  var name: String?

  init(id: Int64?, name: String?) {

    self.id = id
    self.name = name
  }

}
