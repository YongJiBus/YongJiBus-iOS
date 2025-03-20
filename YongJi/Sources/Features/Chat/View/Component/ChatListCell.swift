//
//  ChatListCell.swift
//  YongJiBus
//
//  Created by bryan on 9/13/24.
//

import SwiftUI

struct ChatListCell: View {
    let chatRoom: ChatRoom

    var body: some View {
        OptionRow{
            VStack(alignment: .leading, spacing: 8) {
                Text(chatRoom.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    Text("\(chatRoom.departureTime)")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack {
                Image(systemName: "person.3")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                Text("\(chatRoom.members)/5")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ChatListCell(chatRoom: ChatRoom(id: 1, name: "Sample Room",departureTime: "12:00", members: 3))
}
