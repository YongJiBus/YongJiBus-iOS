//
//  ChattingListView.swift
//  YongJiBus
//
//  Created by bryan on 9/13/24.
//

import SwiftUI

struct ChattingListView: View {
    @StateObject private var viewModel = ChattingListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.chatRooms, id: \.name) { chatRoom in
                        NavigationLink(destination: ChatRoomView(chatRoom: chatRoom)) {
                            ChatListCell(chatRoom: chatRoom)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ChattingListView()
}
