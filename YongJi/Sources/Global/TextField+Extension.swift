//
//  TextField+Extension.swift
//  YongJiBus
//
//  Created by 김도경 on 2/21/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import SwiftUI

struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > maxLength {
                    text = oldValue
                }
            }
    }
}


extension TextField {
    func maxLength(text: Binding<String>, _ maxLength: Int) -> some View {
        return ModifiedContent(content: self,
                               modifier: MaxLengthModifier(text: text,
                                                           maxLength: maxLength))
    }
}
