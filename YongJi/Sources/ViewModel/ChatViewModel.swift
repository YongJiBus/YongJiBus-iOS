//
//  ChatViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2/24/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import RxSwift

class ChatViewModel : ObservableObject {
    @Published var messages: [ChatMessage] = []
    private let webSocketService: WebSocketService
    private let chatRepository: ChatRepository
    private let disposeBag = DisposeBag()
    private var currentRoomId: Int64?
    
    init() {
        self.webSocketService = WebSocketService.shared
        self.chatRepository = ChatRepository.shared
        webSocketService.messageSubject
            .observe(on: MainScheduler.instance)
            .subscribe { message in
                print("메시지 수신: \(message)")
                self.messages.append(message)
            }
            .disposed(by: disposeBag)
    }

    public func connectWebSocket() {
        webSocketService.connect()
    }
    
    func subscribeToRoom(roomId: Int64) {
        self.currentRoomId = roomId
        webSocketService.subscribeToRoom(roomId: roomId)

    }
    
    func sendMessage(roomId: Int64, content: String) {
        webSocketService.sendMessage(roomId: roomId, content: content)
    }

    func getChatMessages(roomId: Int64) {
        chatRepository.getChatMessages(roomId: roomId)
            .subscribe { chatMessages in
                self.messages = chatMessages.map{ $0.toModel() }
            }
            .disposed(by: disposeBag)
    }
    
    /// 연결 종료
    func disconnect() {
        webSocketService.disconnect()
    }
}
