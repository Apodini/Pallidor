import Foundation

/** The combination of start date, end date and a weekday pattern */


class _PeriodOfOperation: Codable {


var daysOfOperation: String?
var endDate: String?
var startDate: String?

init(daysOfOperation: String?, endDate: String?, startDate: String?) {

        self.daysOfOperation = daysOfOperation
self.endDate = endDate
self.startDate = startDate
    }
    
}
