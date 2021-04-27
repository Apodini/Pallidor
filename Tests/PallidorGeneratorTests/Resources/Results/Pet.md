import Foundation



class _Pet: Codable {


//sourcery: isCustomType
var category: _Category
var id: Int64?
var name: String
var photoUrls: [String]/** pet status in the store */
//sourcery: isEnumType
var status: Status?

enum Status: String, Codable, CaseIterable {

case available = "available"
case pending = "pending"
case sold = "sold"

}
//sourcery: isCustomType
var tags: [_Tag]?

init(category: _Category, id: Int64?, name: String, photoUrls: [String], status: Status?, tags: [_Tag]?) {

        self.category = category
self.id = id
self.name = name
self.photoUrls = photoUrls
self.status = status
self.tags = tags
    }
    
}
