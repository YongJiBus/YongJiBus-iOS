//
//  Date+Extension.swift
//  YongJiBus
//
//  Created by Claude on 3/2/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation

extension Date {
    // ISO 8601 문자열을 Date로 변환
    static func fromISO8601(_ string: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string) ?? .now
    }
    
    // Date를 ISO 8601 문자열로 변환
    func toISO8601() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
    
    // 날짜를 "HH:mm" 형식의 문자열로 변환
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // 날짜를 "yyyy-MM-dd HH:mm" 형식의 문자열로 변환
    func toDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    
    // 현재 시간과의 차이를 문자열로 표현 (예: "방금 전", "1분 전", "1시간 전" 등)
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year)년 전"
        } else if let month = components.month, month > 0 {
            return "\(month)개월 전"
        } else if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
    
    // 오늘, 어제, 그제 등을 표시
    func relativeDateDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: self), to: calendar.startOfDay(for: now))
        
        if let day = components.day {
            switch day {
            case 0:
                return "오늘"
            case 1:
                return "어제"
            case 2:
                return "그제"
            default:
                let formatter = DateFormatter()
                formatter.dateFormat = "MM월 dd일"
                return formatter.string(from: self)
            }
        }
        return toDateTimeString()
    }
}
