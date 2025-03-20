//
//  ChatMessageListView.swift
//  YongJiBus
//
//  Created by 김도경 on 3/17/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import SwiftUI

struct ChatMessageListView: UIViewControllerRepresentable{
    typealias UIViewControllerType = ChatMessageListController
    private let viewModel : ChatViewModel
    private let chatRoom : ChatRoom
    
    init(viewModel: ChatViewModel, chatRoom: ChatRoom) {
        self.viewModel = viewModel
        self.chatRoom = chatRoom
    }
    
    func makeUIViewController(context: Context) -> ChatMessageListController {
        let messageListController = ChatMessageListController(viewModel: viewModel, chatRoom: chatRoom)
        return messageListController
    }
    
    func updateUIViewController(_ uiViewController: ChatMessageListController, context: Context) {
        
    }
}

