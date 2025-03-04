//
//  ChatMessageResponseDTO.swift
//  YongJiBus
//
//  Created by 김도경 on 3/3/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//
import Foundation

struct ChatMessageResponseDTO : Codable {
    let id : Int64
    let sender : String
    let content : String
    let roomId : Int64
    let createdAt : String
    
    public func toModel() -> ChatMessage {
        ChatMessage(id: id, sender: sender, content: content, roomId: roomId, timestamp: Date.fromISO8601(createdAt))
    }
}
