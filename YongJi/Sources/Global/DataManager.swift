//
//  DataManager.swift
//  YongJiBus
//
//  Created by 김도경 on 12/21/23.
//
// UserDefaults를 쉽게 사용하기 위한 Manager
import Foundation

@propertyWrapper
struct MyDefaults<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

public enum DataManager {
    enum Key: String {
        case weekend, holidayAutomation
    }
    
    @MyDefaults(key: Key.weekend.rawValue, defaultValue: false)
    public static var weekend

    @MyDefaults(key: Key.holidayAutomation.rawValue, defaultValue: false)
    public static var holidayAutomation
}
