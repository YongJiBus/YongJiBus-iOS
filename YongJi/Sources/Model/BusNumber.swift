//
//  BusNumber.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/07/05.
//

enum BusNumber : String, CaseIterable {
    case oneA
    case oneB
    case zero
//    case six
}

extension BusNumber {
    var title : String {
        switch self{
        case .zero :
            return  "5000B"
        case .oneA :
            return "5001-1A"
        case .oneB :
            return "5001-1B"
//        case .six:
//            return "5600"
        }
    }
    
    var route : String {
        switch self{
        case .zero :
            return "228000174"
        case .oneA:
            return "228000430"
        case .oneB:
            return "228000177"
//        case .six:
//            return "228000184"
        }
    }
}
