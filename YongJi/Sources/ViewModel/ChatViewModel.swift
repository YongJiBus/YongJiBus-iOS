//
//  ChatViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 2/24/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation

class ChatViewModel : ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession
    private var isConnected = false
    
    // STOMP 프레임 관련 상수
    private let stompConnectFrame = """
        CONNECT
        accept-version:1.2
        heart-beat:10000,10000

        \u{0}
        """
    
    private let stompSubscribeFrame = """
        SUBSCRIBE
        id:sub-0
        destination:/sub/message
        ack:auto

        \u{0}
        """
    
    @Published var messages: [ChatMessage] = []
    private var messageHandler: ((ChatMessage) -> Void)?
    
    init() {
        // 기본 URLSession 생성 (delegate, configuration 필요시 추가)
        self.urlSession = URLSession(configuration: .default)
        connect()
        
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
        send(message: stompConnectFrame)
        
        // 구독 설정
        send(message: stompSubscribeFrame)
        
        // 메시지 수신 시작
        receiveMessage()
    }
    
    /// STOMP 메시지 전송
    func sendStompMessage(message: String, destination: String = "/pub/message") {
        let stompMessage = """
        SEND
        destination:\(destination)
        content-type:application/json
        content-length:\(message.utf8.count)

        \(message)\u{0000}
        """
        send(message: stompMessage)
    }
    
    /// 메시지 수신
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
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
            print("STOMP 연결 성공")
            isConnected = true
        case "MESSAGE":
            if let data = body.data(using: .utf8) {
                do {
                    let messageData = try JSONDecoder().decode(ChatMessage.self, from: data)
                    DispatchQueue.main.async {
                        self.messageHandler?(messageData)
                    }
                } catch {
                    print("메시지 디코딩 실패: \(error)")
                }
            }
        default:
            print("기타 STOMP 프레임: \(command)")
        }
    }
    
    /// 메시지 전송
    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("웹소켓 메시지 전송 실패: \(error)")
            } else {
                print("메시지 전송 성공")
            }
        }
    }
    
    /// 연결 종료
    func disconnect() {
        if isConnected {
            let disconnectFrame = "DISCONNECT\n\n\u{0}"
            send(message: disconnectFrame)
        }
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func subscribeToRoom(roomId: Int, onMessageReceived: @escaping (ChatMessage) -> Void) {
        self.messageHandler = onMessageReceived
        
        let subscribeFrame = """
            SUBSCRIBE
            destination:/topic/chat

            \u{0}
            """
        
        send(message: subscribeFrame)
    }
    
    func sendMessage(roomId: Int, content: String) {
        let message = ChatMessageDTO(
            sender: "테스트", // TODO: 실제 사용자 정보로 대체 필요
            content: content
        )
        
        do {
            let data = try JSONEncoder().encode(message)
            if let jsonString = String(data: data, encoding: .utf8) {
                sendStompMessage(message: jsonString, destination: "/pub/chat/message")
            }
        } catch {
            print("메시지 변환 실패: \(error)")
        }
    }
}


struct ChatMessageDTO : Encodable {
    let sender : String
    let content : String
}
