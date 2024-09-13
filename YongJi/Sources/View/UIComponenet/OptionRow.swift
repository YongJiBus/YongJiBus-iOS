//
//  OptionRow.swift
//  YongJiBus
//
//  Created by 김도경 on 12/28/23.
//

import SwiftUI

struct OptionRow<Content> : View where Content : View {
    let content : () -> Content
    
    @inlinable public init( @ViewBuilder content: @escaping () -> Content){
        self.content = content
    }
 
    var body: some View {
        HStack{
            content()
        }
        .padding()
        .background(Color("RowColor"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    OptionRow(){
        Text("Test")
    }
}
