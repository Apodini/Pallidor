/**


Responses:
   - 405: Invalid input
*/
static func updatePetWithForm(name: String, petId: Int64, status: String, authorization: HTTPAuthorization = NetworkManager.authorization!, contentType: String? = NetworkManager.defaultContentType) -> AnyPublisher<String, Error> {
var path = NetworkManager.basePath! + "/pet/{petId}"
NetworkManager.assertPathParameters(petId)
path = path.replacingOccurrences(of: "{petId}", with: petId.description)
path += "?name=\(name.description)&status=\(status.description)"

    return NetworkManager.postElement(authorization: authorization, on: URL(string: path)!, contentType: contentType)
.tryMap { data, response in
        guard let r = response as? HTTPURLResponse, 200..<299 ~= r.statusCode else {
        let httpResponse = response as! HTTPURLResponse

        if httpResponse.statusCode == 405 {
    throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: 405)))
}

            throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: httpResponse.statusCode)))
        }
        return String(data: data, encoding: .utf8)!
}
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
}
