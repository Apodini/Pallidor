import Foundation

/** A FlightAggregate is a date_wise aggregation of otherwise single_dated flights. I.e. flights with identical attributes are aggregated into periods of operation. */


class _FlightAggregate: Codable {


var airline: String?/** The data elements */
//sourcery: isCustomType
var dataElements: [_DataElement]?
var flightNumber: Int?/** The legs */
//sourcery: isCustomType
var legs: [_Leg]?
//sourcery: isCustomType
var periodOfOperationLT: _PeriodOfOperation?
//sourcery: isCustomType
var periodOfOperationUTC: _PeriodOfOperation?
var suffix: String?

init(airline: String?, dataElements: [_DataElement]?, flightNumber: Int?, legs: [_Leg]?, periodOfOperationLT: _PeriodOfOperation?, periodOfOperationUTC: _PeriodOfOperation?, suffix: String?) {

        self.airline = airline
self.dataElements = dataElements
self.flightNumber = flightNumber
self.legs = legs
self.periodOfOperationLT = periodOfOperationLT
self.periodOfOperationUTC = periodOfOperationUTC
self.suffix = suffix
    }
    
}
