import Foundation

struct ArrivalTimeList : Decodable {
    let timeId: Int
    var arrivalTimes: [String]
    
    init(timeId : Int){
        self.timeId = timeId
        arrivalTimes = []
    }
}
