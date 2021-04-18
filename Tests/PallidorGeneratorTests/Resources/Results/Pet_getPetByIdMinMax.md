/**
Returns a single pet

Responses:
   - 200: successful operation
   - 400: Invalid ID supplied
   - 404: Pet not found
*/
static func getPetById(petId: Int64, authorization: HTTPAuthorization = NetworkManager.authorization!, contentType: String? = NetworkManager.defaultContentType) -> AnyPublisher<_Pet, Error> {
var path = NetworkManager.basePath! + "/pet/{petId}"
    path = path.replacingOccurrences(of: "{petId}", with: String(petId))


        assert(petId >= 1 && petId <= 100, "petId exceeds its limits")
return NetworkManager.getElement(on: URL(string: path)!, authorization: authorization, contentType: contentType)
.tryMap { data, response in
        guard let r = response as? HTTPURLResponse, 200..<299 ~= r.statusCode else {
        let httpResponse = response as! HTTPURLResponse

        if httpResponse.statusCode == 400 {
    throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: 400)))
}
if httpResponse.statusCode == 404 {
    let content = String(data: data, encoding: .utf8)!
throw _OpenAPIError.responseStringError(404, content)
}

            throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: httpResponse.statusCode)))
        }
        return data
}
.decode(type: _Pet.self, decoder: decoder)
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
}
