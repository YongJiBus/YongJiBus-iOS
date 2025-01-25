//
//  DayTypeResponseDTO.swift
//  YongJiBus
//
//  Created by 김도경 on 1/24/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//
import Foundation

struct DayTypeResponseDTO : Decodable {
    let date : Date
    let dateKind : String
    let isHoliday : Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let parsedDate = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        
        self.date = parsedDate
        self.dateKind = try container.decode(String.self, forKey: .dateKind)
        self.isHoliday = try container.decode(Bool.self, forKey: .isHoliday)
    }
    
    private enum CodingKeys : String , CodingKey {
        case date = "date"
        case dateKind = "dateKind"
        case isHoliday = "holiday"
    }
}

extension DayTypeResponseDTO {
    func toEntity() -> DateInfo{
        return DateInfo(date: date, dateKind: dateKind)
    }
}
