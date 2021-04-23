/**
This operation returns schedules related only to passenger flights.
In case a flight is marked both as cargo and passenger it will also be returned.

Responses:
   - 200: Successful operation
   - 206: Result truncated
   - 400: Validation error
   - 401: Authentication required
   - 404: Flight not found
   - 500: Server error
*/
static func getPassengerFlights(aircraftTypes: [String]?, airlines: [String], daysOfOperation: String, destination: String?, endDate: String, flightNumberRanges: String?, origin: String?, startDate: String, timeMode: String, authorization: HTTPAuthorization = NetworkManager.authorization!, contentType: String? = NetworkManager.defaultContentType) -> AnyPublisher<[_FlightAggregate], Error> {
var path = NetworkManager.basePath! + "/flightschedules/passenger"

path += "?\(aircraftTypes != nil ? "&aircraftTypes=\(aircraftTypes?.joined(separator: "&") ?? "")" : "")&airlines=\(airlines.joined(separator: "&"))&daysOfOperation=\(daysOfOperation.description)\(destination != nil ? "&destination=\(destination?.description ?? "")" : "")&endDate=\(endDate.description)\(flightNumberRanges != nil ? "&flightNumberRanges=\(flightNumberRanges?.description ?? "")" : "")\(origin != nil ? "&origin=\(origin?.description ?? "")" : "")&startDate=\(startDate.description)&timeMode=\(timeMode.description)"

    return NetworkManager.getElement(on: URL(string: path)!, authorization: authorization, contentType: contentType)
.tryMap { data, response in
        guard let r = response as? HTTPURLResponse, 200..<299 ~= r.statusCode else {
        let httpResponse = response as! HTTPURLResponse

        if httpResponse.statusCode == 400 {
    let content = try decoder.decode(_ErrorResponse.self, from: data)
throw _OpenAPIError.response_ErrorResponseError(400, content)
}
if httpResponse.statusCode == 401 {
    let content = try decoder.decode(_ErrorResponse.self, from: data)
throw _OpenAPIError.response_ErrorResponseError(401, content)
}
if httpResponse.statusCode == 404 {
    let content = try decoder.decode(_ErrorResponse.self, from: data)
throw _OpenAPIError.response_ErrorResponseError(404, content)
}
if httpResponse.statusCode == 500 {
    let content = try decoder.decode(_ErrorResponse.self, from: data)
throw _OpenAPIError.response_ErrorResponseError(500, content)
}

            throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: httpResponse.statusCode)))
        }
        return data
}
.decode(type: [_FlightAggregate].self, decoder: decoder)
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
}
