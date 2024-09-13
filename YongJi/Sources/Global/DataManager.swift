//
//  UserDefault.swift
//  YongJiBus
//
//  Created by 김도경 on 12/21/23.
//
// UserDefaults를 쉽게 사용하기 위한 Manager

import Foundation

class DataManager {
    
    enum dataTypes : String {
        case weekend
    }
    
    static private let defaults = UserDefaults.standard
    
    static public func setData<T>(data : T, key: dataTypes){
        defaults.setValue(data, forKey: key.rawValue)
    }
    
    static public func getData(key: dataTypes) -> Any{
        switch key{
        case .weekend:
            return defaults.bool(forKey: key.rawValue)
        }
    }
}
