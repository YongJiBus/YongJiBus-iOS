//
//  BusNumber.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//

enum BusNumber : String {
    case one
    case three
    case zero
}

extension BusNumber {
    var title : String {
        switch self{
        case .one :
            return "5001-1"
        case .three :
            return  "5003B"
        case .zero :
            return  "5000B"
        }
    }
    
    var route : String {
        switch self{
        case .three :
            return "228000182"
        case .zero :
            return "228000174"
        case .one:
            return "228000177"
        }
    }
}
