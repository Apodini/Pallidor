/**
Update an existing pet by Id
RequestBody:
   - element Update an existent pet in the store
Responses:
   - 200: Successful operation
   - 400: Invalid ID supplied
   - 404: Pet not found
   - 405: Validation exception
*/
static func updatePet(element: _Pet, authorization: HTTPAuthorization = NetworkManager.authorization!, contentType: String? = NetworkManager.defaultContentType) -> AnyPublisher<_Pet, Error> {
let path = NetworkManager.basePath! + "/pet"
    


    return NetworkManager.patchElement(element, authorization: authorization, on: URL(string: path)!, contentType: contentType)
.tryMap { data, response in
        guard let r = response as? HTTPURLResponse, 200..<299 ~= r.statusCode else {
        let httpResponse = response as! HTTPURLResponse

        if httpResponse.statusCode == 400 {
    throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: 400)))
}
if httpResponse.statusCode == 404 {
    throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: 404)))
}
if httpResponse.statusCode == 405 {
    throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: 405)))
}

            throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: httpResponse.statusCode)))
        }
        return data
}
.decode(type: _Pet.self, decoder: decoder)
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
}
