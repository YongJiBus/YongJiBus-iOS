//
//  BusNumber.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//

enum BusNumber : String {
    case one
    case zero
}

extension BusNumber {
    var title : String {
        switch self{
        case .one :
            return "5001-1"
        case .zero :
            return  "5000B"
        }
    }
    
    var route : String {
        switch self{
        case .zero :
            return "228000174"
        case .one:
            return "228000177"
        }
    }
}
