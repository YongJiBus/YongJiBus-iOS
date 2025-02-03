import Foundation

struct SaveArrivalTimeRequestDTO: Codable {
    let busId: Int
    let date: String
    let time: String
    let isHoliday: Bool
    
    init(busId: Int, arrivalTime: Date, isHoliday: Bool) {
        self.busId = busId
        self.isHoliday = isHoliday
        
        self.date = DateFormatter.yearMonthDay.string(from: .now)
        self.time = DateFormatter.hourMinute.string(from: arrivalTime)
    }
} 
