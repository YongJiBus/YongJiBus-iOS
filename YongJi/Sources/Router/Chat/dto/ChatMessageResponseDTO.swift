//
//  ChatMessageResponseDTO.swift
//  YongJiBus
//
//  Created by 김도경 on 3/3/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//
import Foundation

struct ChatMessageResponseDTO : Codable {
    let messageType : ChatMessageType
    let id : Int64
    let sender : String
    let content : String
    let roomId : Int64
    let createdAt : String
    
    public func toModel() -> ChatMessage {
        ChatMessage(messageType: messageType, id: id, sender: sender, content: content, roomId: roomId, timestamp: Date.fromISO8601(createdAt))
    }
}

// 페이지네이션을 위한 응답 구조체 (서버 응답 형식에 맞게 수정)
struct SliceResponse<T: Codable>: Codable {
    let content: [T]
    let hasNext: Bool
    let number: Int
    let size: Int
}
