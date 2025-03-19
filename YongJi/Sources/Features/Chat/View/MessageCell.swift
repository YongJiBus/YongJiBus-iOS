// ChatMessage 값에 따라 다른 뷰를 보여주는 셀
// 1. 내가 보낸 셀이면 -> SenderMessageBubble
// 2. 상대방이 보낸 셀이면 -> MessageBubble
// 3. 사용자 입장 메시지면 -> UserEnterMessageBubble
// 4. 사용자 퇴장 메시지면 -> UserExitMessageBubble

// 상대방이 보낸 셀이면 .contextMenu로 Button을 받아 올 수 있어야함

import SwiftUI

struct MessageCell: View {
    let chatMessage: ChatMessage
    let isMyMessage: Bool
    let onReport: (() -> Void)?
    let nextMessage: ChatMessage?
    let previousMessage: ChatMessage?
    
    init(chatMessage: ChatMessage, isMyMessage: Bool, nextMessage: ChatMessage? = nil, previousMessage: ChatMessage? = nil, onReport: (() -> Void)? = nil) {
        self.chatMessage = chatMessage
        self.isMyMessage = isMyMessage
        self.nextMessage = nextMessage
        self.previousMessage = previousMessage
        self.onReport = onReport
    }
    
    // 다음 메시지가 같은 사용자이고 같은 시간대인지 확인하는 함수
    private func hasNextContinuousMessage() -> Bool {
        guard let nextMessage = nextMessage else { return false }
        
        // 같은 사용자인지 확인
        let sameSender = nextMessage.sender == chatMessage.sender
        
        // 같은 시간대인지 확인 (1분 이내)
        let calendar = Calendar.current
        let timeDifference = calendar.dateComponents([.minute], from: chatMessage.timestamp, to: nextMessage.timestamp)
        let withinTimeFrame = timeDifference.minute ?? 0 < 1
        
        return sameSender && withinTimeFrame && nextMessage.messageType == .message && chatMessage.messageType == .message
    }
    
    // 이전 메시지가 같은 사용자인지 확인하는 함수
    private func hasPreviousContinuousMessage() -> Bool {
        guard let previousMessage = previousMessage else { return false }
        
        // 같은 사용자인지 확인
        let sameSender = previousMessage.sender == chatMessage.sender
        
        // 같은 시간대인지 확인 (1분 이내)
        let calendar = Calendar.current
        let timeDifference = calendar.dateComponents([.minute], from: previousMessage.timestamp, to: chatMessage.timestamp)
        let withinTimeFrame = timeDifference.minute ?? 0 < 1
        
        return sameSender && withinTimeFrame && previousMessage.messageType == .message && chatMessage.messageType == .message
    }
    
    var body: some View {
        Group {
            if chatMessage.messageType == .enter {
                // 사용자 입장 메시지
                UserEnterMessageBubble(chatMessage: chatMessage)
            } else if chatMessage.messageType == .exit {
                // 사용자 퇴장 메시지
                UserExitMessageBubble(chatMessage: chatMessage)
            } else if chatMessage.messageType == .system {
                // 시스템 경고 메시지
                SystemWarningMessageBubble(chatMessage: chatMessage)
            } else if isMyMessage {
                // 내가 보낸 메시지
                SenderMessageBubble(chatMessage: chatMessage, showTimestamp: !hasNextContinuousMessage())
            } else {
                // 상대방이 보낸 메시지
                MessageBubble(
                    chatMessage: chatMessage, 
                    showTimestamp: !hasNextContinuousMessage(),
                    showSender: !hasPreviousContinuousMessage()
                )
                .contextMenu {
                    if let onReport = onReport {
                        Button(action: onReport) {
                            Label("신고하기", systemImage: "exclamationmark.triangle")
                        }
                    }
                }
            }
        }
        .padding(.vertical, 0)
        .listRowSeparator(.hidden)
        .id(chatMessage.id)
    }
}

// 사용자 입장 메시지 버블
struct UserEnterMessageBubble: View {
    let chatMessage: ChatMessage
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(chatMessage.sender)님이 입장하셨습니다")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            Spacer()
        }
    }
}

// 사용자 퇴장 메시지 버블
struct UserExitMessageBubble: View {
    let chatMessage: ChatMessage
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(chatMessage.sender)님이 퇴장하셨습니다")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.vertical, 1)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            Spacer()
        }
    }
}

// 시스템 경고 메시지 버블 (부드러운 버전)
struct SystemWarningMessageBubble: View {
    let chatMessage: ChatMessage
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.white)
                    Text("안내")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                }
                
                Text(chatMessage.content)
                    .font(.caption)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// 미리보기
#Preview {
    VStack(spacing: 20) {
        // 연속된 내 메시지 예시
        let firstMessage = ChatMessage(
            messageType: .message,
            id: 1,
            sender: "나",
            content: "안녕하세요!",
            roomId: 1,
            timestamp: Date()
        )
        
        let secondMessage = ChatMessage(
            messageType: .message,
            id: 2,
            sender: "나",
            content: "반갑습니다!",
            roomId: 1,
            timestamp: Date()
        )
        
        let thirdMessage = ChatMessage(
            messageType: .message,
            id: 3,
            sender: "나",
            content: "오늘 날씨가 좋네요!",
            roomId: 1,
            timestamp: Date()
        )
        
        // 첫 번째 메시지 (다음 메시지가 있으므로 시간 표시 없음)
        MessageCell(
            chatMessage: firstMessage,
            isMyMessage: true,
            nextMessage: secondMessage
        )
        
        // 중간 메시지 (다음 메시지가 있으므로 시간 표시 없음)
        MessageCell(
            chatMessage: secondMessage,
            isMyMessage: true,
            nextMessage: thirdMessage
        )
        
        // 마지막 메시지 (다음 메시지가 없으므로 시간 표시 있음)
        MessageCell(
            chatMessage: thirdMessage,
            isMyMessage: true
        )
        
        // 연속된 상대방 메시지 예시
        let otherFirstMessage = ChatMessage(
            messageType: .message,
            id: 4,
            sender: "홍길동",
            content: "안녕하세요!",
            roomId: 1,
            timestamp: Date()
        )
        
        let otherSecondMessage = ChatMessage(
            messageType: .message,
            id: 5,
            sender: "홍길동",
            content: "오늘 날씨가 정말 좋네요!",
            roomId: 1,
            timestamp: Date()
        )
        
        // 상대방 첫 번째 메시지 (이름 표시)
        MessageCell(
            chatMessage: otherFirstMessage,
            isMyMessage: false,
            nextMessage: otherSecondMessage,
            onReport: {}
        )
        
        // 상대방 두 번째 메시지 (이전 메시지와 같은 발신자이므로 이름 표시 없음)
        MessageCell(
            chatMessage: otherSecondMessage,
            isMyMessage: false,
            previousMessage: otherFirstMessage,
            onReport: {}
        )
        
        // 입장 메시지
        MessageCell(
            chatMessage: ChatMessage(
                messageType: .enter,
                id: 6,
                sender: "김철수",
                content: "",
                roomId: 1,
                timestamp: Date()
            ),
            isMyMessage: false
        )
        
        // 퇴장 메시지
        MessageCell(
            chatMessage: ChatMessage(
                messageType: .exit,
                id: 7,
                sender: "이영희",
                content: "",
                roomId: 1,
                timestamp: Date()
            ),
            isMyMessage: false
        )
        
        // 시스템 경고 메시지
        MessageCell(
            chatMessage: ChatMessage(
                messageType: .system,
                id: 8,
                sender: "SYSTEM",
                content: "욕설 및 부적절한 표현이 감지되었습니다. 건전한 대화를 부탁드립니다.",
                roomId: 1,
                timestamp: Date()
            ),
            isMyMessage: false
        )
    }
    .padding()
}
