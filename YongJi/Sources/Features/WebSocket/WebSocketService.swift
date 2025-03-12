//
//  WebSocketService.swift
//  YongJiBus
//
//  Created by Claude on 3/2/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import RxSwift
import UserNotifications

class WebSocketService {
    static let shared = WebSocketService()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession
    private var isConnected = false
    
    // RxSwift 관련
    public let messageSubject = PublishSubject<ChatMessage>()
    public let errorSubject = PublishSubject<String>()
    
    // STOMP 프레임 관련 상수
    private let stompConnectFrame = """
        CONNECT
        accept-version:1.2
        authorization:Bearer \(SecureDataManager.shared.getData(label: .accessToken))
        
        \u{0}
        """
    
    // 현재 활성화된 채팅방 ID
    private var activeRoomId: Int64?
    
    private init() {
        // 기본 URLSession 생성 (delegate, configuration 필요시 추가)
        self.urlSession = URLSession(configuration: .default)
    }

    func subscribeToRoom(roomId: Int64) {
        let subscribeFrame = """
        SUBSCRIBE
        id: sub-\(roomId)
        destination:/sub/chat/room/\(roomId)
        
        \u{0000}
        """
        
        sendMessageToServer(message: subscribeFrame)
    }
    
    func sendChatMessage(roomId: Int64, content: String) {
        let message = ChatMessageSendDTO(
            sender: UserManager.shared.currentUser?.nickname ?? "익명",
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
    
    /// 웹소켓 연결 생성 및 STOMP 연결
    func connect() {
        // 웹소켓 서버 URL (ws:// 또는 wss://)
        guard let url = URL(string: "ws://localhost:8080/ws-stomp") else {
            print("Invalid URL")
            return
        }
        // URLSessionWebSocketTask 생성
        var request = URLRequest(url: url)
        
        let accesToken = "Bearer \(SecureDataManager.shared.getData(label: .accessToken))"
        
        request.setValue(accesToken, forHTTPHeaderField: "Authorization")
        webSocketTask = urlSession.webSocketTask(with:request)
        webSocketTask?.resume()
        
        let stompConnectFrame = """
            CONNECT
            accept-version:1.2
            authorization:\(accesToken)
            
            \u{0}
            """
        
        // STOMP 연결 프레임 전송
        sendMessageToServer(message: stompConnectFrame)
        isConnected = true
        // 메시지 수신 시작
        receiveMessage()
        // 클라이언트 Ping 시작
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
        sendMessageToServer(message: stompMessage)
    }
    
    /// 메시지 서버에 전송
    private func sendMessageToServer(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if error != nil {
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
            case .failure(_):
                self?.isConnected = false
                self?.errorSubject.onNext("🌐 네트워크 오류: 재입장 해주세요")
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
            if body.trimmingCharacters(in: .whitespacesAndNewlines) == "PING" {
                // PING 메시지를 받으면 PONG으로 응답
                let pongFrame = """
                    SEND
                    destination:/pub/chat/message
                    content-type:application/json
                    
                    {"type":"PONG"}
                    \u{00}
                    """
                self.sendMessageToServer(message: pongFrame)
                print("STOMP Pong 메시지 전송")
            } else if let data = body.data(using: .utf8) {
                do {
                    let messageData = try JSONDecoder().decode(ChatMessageResponseDTO.self, from: data)
                    // RxSwift Subject를 통해 메시지 전달
                    messageSubject.onNext(messageData.toModel())
                    
                    // 현재 활성화된 채팅방이 아니면 푸시 알림 전송
                    if messageData.roomId != activeRoomId {
                        sendLocalNotification(for: messageData)
                    }
                } catch {
                    print("메시지 디코딩 실패: \(error)")
                }
            }
        default:
            print("기타 STOMP 프레임: \(command)")
        }
    }

    func setActiveRoom(roomId: Int64) {
        self.activeRoomId = roomId
    }
    
    // 활성 채팅방 설정 해제
    func unsetActiveRoom() {
        self.activeRoomId = nil
    }
    
    // 로컬 푸시 알림 전송
    private func sendLocalNotification(for message: ChatMessageResponseDTO) {
        let content = UNMutableNotificationContent()
        content.title = "용지버스"
        content.body = "\(message.sender): \(message.content)"
        content.sound = .default
        
        // 알림 요청 생성
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        // 알림 요청 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 전송 실패: \(error)")
            }
        }
    }
    
    /// 연결 종료
    func disconnect() {
        if isConnected {
            print("Websocket 정상 종료")
            let disconnectFrame = "DISCONNECT\n\n\u{0}"
            sendMessageToServer(message: disconnectFrame)
        }
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
