//
//  ChatListCell.swift
//  YongJiBus
//
//  Created by bryan on 9/13/24.
//

import SwiftUI

struct ChatListCell: View {

    var body: some View {
        ScrollView{
            ForEach(0..<13) { _ in
                rowExample
            }
        }
        Spacer()
    }
    
    var rowExample : some View {
        OptionRow(content: {
            Text("채팅방 이름 오ㅓㅏ르르를")
            Spacer()
            VStack{
                Text("시간")
                    .fontWeight(.light)
                    .font(.caption)
                Text("10:00")
            }
            .padding(.trailing, 15)
            
            VStack{
                Text("인원")
                    .fontWeight(.light)
                    .font(.caption)
                Text("3/4")
            }
            
        })
        .padding(.horizontal)
    }
}

#Preview {
    ChatListCell()
}
