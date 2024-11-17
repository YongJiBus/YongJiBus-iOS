//
//  Queriable.swift
//  YongJiBus
//
//  Created by 김도경 on 11/16/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//

protocol Queriable {
    var key : String { get set }
    var value : String { get set }
}

extension Queriable {
    func toQueryParameter() -> Dictionary<String,String> {
        [key:value]
    }
}
