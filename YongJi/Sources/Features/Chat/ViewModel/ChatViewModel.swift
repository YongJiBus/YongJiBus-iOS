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
    @Published var showReportAlert: Bool = false
    @Published var messageToReport: ChatMessage? = nil
    @Published var isReporting: Bool = false
    @Published var reportSuccess: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMoreMessages: Bool = true
    @Published var isFirstLoading = true
    @Published var shouldScrollToBottom: Bool = false
    
    private let chatRoom: ChatRoom
    private let webSocketService: WebSocketService
    private let chatRepository: ChatRepository
    private let memberReportRepository: MemberReportRepository
    private let disposeBag = DisposeBag()
    private var currentRoomId: Int64?
    private var currentPage: Int = 0
    private var pageSize: Int = 30
    public var lastMessage: ChatMessage?
    
    init(chatRoom: ChatRoom) {
        self.webSocketService = WebSocketService.shared
        self.chatRepository = ChatRepository.shared
        self.memberReportRepository = MemberReportRepository.shared
        self.chatRoom = chatRoom
        
        webSocketService.messageSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { _, message in
                if message.roomId == self.chatRoom.id {
                    self.messages.append(message)
                }
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
        if webSocketService.getActiveRoom() == nil {
            webSocketService.subscribeToRoom(roomId: roomId)
            webSocketService.setActiveRoom(roomId: roomId)
        } else if let activeRoom = webSocketService.getActiveRoom(), activeRoom != roomId {
            webSocketService.subscribeToRoom(roomId: roomId)
            webSocketService.setActiveRoom(roomId: roomId)
        }
    }

    func leaveChat(){
        guard let roomId = currentRoomId else { return }
        webSocketService.unsubscribeRoom(roomId: roomId)
        chatRepository.leaveChatRoom(roomId: roomId)
            .subscribe { _ in
            }
            .disposed(by: disposeBag)
    }

    func unsetActiveRoom() {
        webSocketService.unsetActiveRoom()
    }
    
    func sendMessage(roomId: Int64, content: String) {
        webSocketService.sendChatMessage(roomId: roomId, content: content)
    }

    func getChatMessages(roomId: Int64) {
        chatRepository.getChatMessages(roomId: roomId, page: currentPage, size: pageSize)
            .subscribe(onSuccess: { [weak self] sliceResponse in
                let newMessages = sliceResponse.content.map{ $0.toModel() }
                self?.messages = newMessages
                self?.currentPage += 1
                self?.isFirstLoading = false
                self?.shouldScrollToBottom = true
                self?.lastMessage = newMessages.last
                self?.hasMoreMessages = sliceResponse.hasNext
            }, onFailure: { error in
                self.errorMessage = "메시지를 불러오는 중 오류가 발생했습니다: \(error.localizedDescription)"
                self.showError = true
            })
            .disposed(by: disposeBag)
    }
    
    func loadMoreMessages() {
        guard let roomId = currentRoomId, hasMoreMessages, !isLoadingMore else { return }
        
        isLoadingMore = true
        
        chatRepository.getChatMessages(roomId: roomId, page: currentPage, size: pageSize)
            .subscribe(onSuccess: { sliceResponse in
                DispatchQueue.main.async {
                    let newMessages = sliceResponse.content.map{ $0.toModel() }
                    self.messages.insert(contentsOf: newMessages, at: 0)
                    self.hasMoreMessages = sliceResponse.hasNext
                    self.isLoadingMore = false
                    self.currentPage += 1
                }
            }, onFailure: { error in
                self.errorMessage = "추가 메시지를 불러오는 중 오류가 발생했습니다: \(error.localizedDescription)"
                self.showError = true
                self.isLoadingMore = false
            })
            .disposed(by: disposeBag)
    }

    func disconnect() {
        webSocketService.disconnect()
    }
    
    func dismissNewMessageBanner() {
        showNewMessageBanner = false
    }
    
    func reportMessage(message: ChatMessage, reason: String) {
        guard let roomId = currentRoomId else {
            errorMessage = "메시지 신고에 필요한 정보가 부족합니다."
            showError = true
            return
        }
        
        isReporting = true
        
        memberReportRepository.reportUser(
            reason: reason,
            roomId: roomId,
            reportedUserName: message.sender
        )
        .subscribe(onSuccess: { [weak self] _ in
            self?.isReporting = false
            self?.reportSuccess = true
            
            // 2초 후 성공 메시지 숨기기
            DispatchQueue.main.async() {
                self?.reportSuccess = false
            }
        }, onFailure: { [weak self] error in
            self?.isReporting = false
            self?.errorMessage = "메시지 신고 중 오류가 발생했습니다: \(error.localizedDescription)"
            self?.showError = true
        })
        .disposed(by: disposeBag)
    }
}
