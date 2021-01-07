import Foundation

class _User: Codable {

  var email: String?
  var firstName: String?
  var id: Int64?
  var lastName: String?
  var password: String?
  var phone: String?
  /** User Status */
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

}
