//
//  TableType.swift
//  YongJiBus
//
//  Created by 김도경 on 12/21/23.
//

import Foundation

enum TableType  {
    case myongji
    case giheung
    case weekend
    
    var type : String {
        switch self{
        case .myongji: return "MyongJiStationTimeTable"
        case .giheung: return "GiheungStationTimeTable"
        case .weekend: return "WeekendTimeTable"
        }
    }
}
