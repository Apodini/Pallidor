import Foundation
import Combine


public struct PetAPI {
    static let decoder : JSONDecoder = NetworkManager.decoder

    public static func addPet(element: Pet , authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = NetworkManager.defaultContentType) -> AnyPublisher<Pet, Error> {

return _PetsAPI.addPet(element: element.to()!, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.map({Pet($0)!})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

public static func deletePet(api_key: String? , petId: Int64 , authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = NetworkManager.defaultContentType) -> AnyPublisher<String, Error> {

return _PetsAPI.deletePet(api_key: api_key, petId: petId, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

public static func findPetsByStatus(status: String? , authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = NetworkManager.defaultContentType) -> AnyPublisher<[Pet], Error> {

return _PetsAPI.findPetsByStatus(status: status, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.map({$0.map({Pet($0)!})})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

public static func findPetsByTags(tags: [String]? , authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = NetworkManager.defaultContentType) -> AnyPublisher<[Pet], Error> {

return _PetsAPI.findPetsByTags(tags: tags, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.map({$0.map({Pet($0)!})})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

public static func getPetById(petId: Int64 , authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = NetworkManager.defaultContentType) -> AnyPublisher<Pet, Error> {

return _PetsAPI.getPetById(petId: petId, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.map({Pet($0)!})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

public static func updatePet(element: Pet , authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = NetworkManager.defaultContentType) -> AnyPublisher<Pet, Error> {

return _PetsAPI.updatePet(element: element.to()!, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.map({Pet($0)!})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

public static func updatePetWithForm(petId: Int64 , name: String , status: String? , element: Pet? = nil, authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = NetworkManager.defaultContentType) -> AnyPublisher<String, Error> {
var element = element

if element == nil {
    let elementTmp : String? = """
        { 'name' : 'Mrs. Fluffy', 'photoUrls': ['xxx'] }
    """

    element = try! JSONDecoder().decode(Pet.self, from: elementTmp!.data(using: .utf8)!)
}
return _PetsAPI.updatePetWithFormNew(petId: petId, name: name, element: element!.to()!, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

public static func uploadFile(petId: Int64 , additionalMetadata: String? , element: String? , authorization: HTTPAuthorization  = NetworkManager.authorization!, contentType: String?  = "application/octet-stream") -> AnyPublisher<ApiResponse, Error> {

return _PetsAPI.uploadFile(petId: petId, additionalMetadata: additionalMetadata, element: element, authorization: authorization, contentType: contentType)
.mapError({( OpenAPIError($0 as? _OpenAPIError)! )})
.map({ApiResponse($0)!})
.receive(on: DispatchQueue.main)
.eraseToAnyPublisher()
}

}