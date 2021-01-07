import Foundation

class _Tag: Codable {

  var id: Int64
  var name: String?

  init(id: Int64, name: String?) {

    self.id = id
    self.name = name
  }

}
