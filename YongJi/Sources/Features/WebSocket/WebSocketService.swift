//
//  WebSocketService.swift
//  YongJiBus
//
//  Created by Claude on 3/2/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import RxSwift

class WebSocketService {
    static let shared = WebSocketService()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession
    private var isConnected = false
    
    // RxSwift 관련
    public let messageSubject = PublishSubject<ChatMessage>()
    
    // STOMP 프레임 관련 상수
    private let stompConnectFrame = """
        CONNECT
        accept-version:1.2

        \u{0}
        """
    
    private init() {
        // 기본 URLSession 생성 (delegate, configuration 필요시 추가)
        self.urlSession = URLSession(configuration: .default)
    }
    
    /// 웹소켓 연결 생성 및 STOMP 연결
    func connect() {
        // 웹소켓 서버 URL (ws:// 또는 wss://)
        guard let url = URL(string: "ws://localhost:8080/ws-stomp") else {
            print("Invalid URL")
            return
        }
        
        // URLSessionWebSocketTask 생성
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        
        // STOMP 연결 프레임 전송
        sendToServer(message: stompConnectFrame)
        isConnected = true
        // 메시지 수신 시작
        receiveMessage()
    }
    
    func subscribeToRoom(roomId: Int64) {
        let subscribeFrame = """
        SUBSCRIBE
        id: sub-\(roomId)
        destination:/sub/chat/room/\(roomId)
        
        \u{0000}
        """
        
        sendToServer(message: subscribeFrame)
    }
    
    func sendMessage(roomId: Int64, content: String) {
        let message = ChatMessageSendDTO(
            sender: UserManager.shared.currentUser?.nickname ?? "익명", // TODO: 실제 사용자 정보로 대체 필요
            content: content,
            roomId: roomId,
            createdAt: Date.now.ISO8601Format()
        )
        do {
            let data = try JSONEncoder().encode(message)
            if let jsonString = String(data: data, encoding: .utf8) {
                makeAndSendStompMessage(message: jsonString)
            }
        } catch {
            print("메시지 변환 실패: \(error)")
        }
    }
    
    /// STOMP 메시지 전송
    private func makeAndSendStompMessage(message: String, destination: String = "/pub/chat/message") {
        let stompMessage = """
        SEND
        destination:\(destination)
        content-type:application/json
        content-length:\(message.utf8.count)

        \(message)\u{0000}
        """
        sendToServer(message: stompMessage)
    }
    
    /// 메시지 서버에 전송
    private func sendToServer(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                self.isConnected = false
            } else {
                self.isConnected = true
            }
        }
    }
    
    /// 메시지 수신
    private func receiveMessage() {
        if !self.isConnected { return }
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.isConnected = false
                print("웹소켓 메시지 수신 실패: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    // STOMP 메시지 파싱 및 처리
                    self?.handleStompMessage(text)
                case .data(let data):
                    print("데이터 메시지 수신: \(data)")
                @unknown default:
                    print("알 수 없는 메시지 타입")
                }
            }
            // 재귀 호출로 계속 수신 대기
            self?.receiveMessage()
        }
    }
    
    private func handleStompMessage(_ message: String) {
        // STOMP 프레임 파싱
        let components = message.components(separatedBy: "\n\n")
        guard components.count >= 2 else { return }
        
        let headers = components[0].components(separatedBy: "\n")
        let command = headers[0]
        let body = components[1].replacingOccurrences(of: "\u{0}", with: "")
        
        switch command {
        case "CONNECTED":
            isConnected = true
        case "MESSAGE":
            if let data = body.data(using: .utf8) {
                do {
                    let messageData = try JSONDecoder().decode(ChatMessageResponseDTO.self, from: data)
                    // RxSwift Subject를 통해 메시지 전달
                    messageSubject.onNext(messageData.toModel())
                } catch {
                    print("메시지 디코딩 실패: \(error)")
                }
            }
        default:
            print("기타 STOMP 프레임: \(command)")
        }
    }
    
    /// 연결 종료
    func disconnect() {
        if isConnected {
            let disconnectFrame = "DISCONNECT\n\n\u{0}"
            sendToServer(message: disconnectFrame)
        }
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
