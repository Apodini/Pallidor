import Foundation

class _Order: Codable {

  var complete: Bool?
  var id: Int64?
  var petId: Int64?
  var quantity: Int32?
  var shipDate: Date?
  /** Order Status */
  //sourcery: isEnumType
  var status: Status?

  enum Status: String, Codable, CaseIterable {

    case placed = "placed"
    case approved = "approved"
    case delivered = "delivered"

  }

  init(
    complete: Bool?, id: Int64?, petId: Int64?, quantity: Int32?, shipDate: Date?, status: Status?
  ) {

    self.complete = complete
    self.id = id
    self.petId = petId
    self.quantity = quantity
    self.shipDate = shipDate
    self.status = status
  }

}
