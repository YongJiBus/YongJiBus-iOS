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
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    @Published var showNewMessageBanner: Bool = false

    
    private let webSocketService: WebSocketService
    private let chatRepository: ChatRepository
    private let disposeBag = DisposeBag()
    private var currentRoomId: Int64?
    
    init() {
        self.webSocketService = WebSocketService.shared
        self.chatRepository = ChatRepository.shared
        webSocketService.messageSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { _, message in
                self.messages.append(message)
            }
            .disposed(by: disposeBag)
        
        webSocketService.errorSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                if let message = error.element {
                    self?.errorMessage = message
                    self?.showError = true
                }
            }
            .disposed(by: disposeBag)
    }

    public func connectWebSocket() {
        webSocketService.connect()
    }
    
    func subscribeToRoom(roomId: Int64) {
        self.currentRoomId = roomId
        webSocketService.subscribeToRoom(roomId: roomId)
        webSocketService.setActiveRoom(roomId: roomId)
    }

    func unsetActiveRoom() {
        webSocketService.unsetActiveRoom()
    }
    
    func sendMessage(roomId: Int64, content: String) {
        webSocketService.sendChatMessage(roomId: roomId, content: content)
    }

    func getChatMessages(roomId: Int64) {
        chatRepository.getChatMessages(roomId: roomId)
            .subscribe(onSuccess: { messagesDTO in
                self.messages = messagesDTO.map{ $0.toModel() }
            })
            .disposed(by: disposeBag)
    }
    
    /// 연결 종료
    func disconnect() {
        webSocketService.disconnect()
    }
    
    func dismissNewMessageBanner() {
        showNewMessageBanner = false
    }
}
