import Foundation

public class User: Codable {
  var email: String?
  var firstName: String?
  var id: Int64?
  var lastName: String?
  var password: String?
  var phone: String?
  var userStatus: Int32?
  var username: String?

  init(
    email: String?, firstName: String?, id: Int64?, lastName: String?, password: String?,
    phone: String?, userStatus: Int32?, username: String?
  ) {
    self.email = email
    self.firstName = firstName
    self.id = id
    self.lastName = lastName
    self.password = password
    self.phone = phone
    self.userStatus = userStatus
    self.username = username
  }

  init?(_ from: _User?) {
    if let from = from {

      self.email = from.email
      self.firstName = from.firstName
      self.id = from.id
      self.lastName = from.lastName
      self.password = from.password
      self.phone = from.phone
      self.userStatus = from.userStatus
      self.username = from.username
    } else {
      return nil
    }
  }

  func to() -> _User? {

    return _User(
      email: self.email, firstName: self.firstName, id: self.id, lastName: self.lastName,
      password: self.password, phone: self.phone, userStatus: self.userStatus,
      username: self.username)
  }

}
