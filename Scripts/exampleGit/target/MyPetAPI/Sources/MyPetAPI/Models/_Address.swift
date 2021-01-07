import Foundation

class _Address: Codable {

  var city: String?
  var state: String?
  var street: String?
  var zip: String?

  init(city: String?, state: String?, street: String?, zip: String?) {

    self.city = city
    self.state = state
    self.street = street
    self.zip = zip
  }

}
