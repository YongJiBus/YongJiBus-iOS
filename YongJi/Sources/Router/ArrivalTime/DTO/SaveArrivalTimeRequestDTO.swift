import Foundation

struct SaveArrivalTimeRequestDTO: Codable {
    let busId: Int
    let date: String
    let arrivalTime: String
    
    init(busId: Int, date: Date, arrivalTime: Date) {
        self.busId = busId
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm"
        self.arrivalTime = dateFormatter.string(from: arrivalTime)
    }
} 