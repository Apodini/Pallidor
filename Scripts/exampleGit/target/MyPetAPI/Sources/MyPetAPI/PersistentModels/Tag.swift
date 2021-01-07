import Foundation

public class Tag: Codable {
  var id: Int64
  var name: String?

  init(id: Int64, name: String?) {
    self.id = id
    self.name = name
  }

  init?(_ from: _Tag?) {
    if let from = from {

      self.id = from.id
      self.name = from.name
    } else {
      return nil
    }
  }

  func to() -> _Tag? {

    return _Tag(id: self.id, name: self.name)
  }

}
