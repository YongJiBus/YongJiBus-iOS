//
//  SecureField+Extension.swift
//  YongJiBus
//
//  Created by 김도경 on 2/22/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import SwiftUI

extension SecureField {
    func coloredBackGround() -> some View {
        return self
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color("RowColor"))
            .cornerRadius(12)
            .autocapitalization(.none)
    }
}
