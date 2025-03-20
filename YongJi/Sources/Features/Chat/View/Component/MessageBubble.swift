import SwiftUI

struct MessageBubble: View {
    let chatMessage: ChatMessage
    let showTimestamp: Bool
    let showSender: Bool
    
    init(chatMessage: ChatMessage, showTimestamp: Bool = true, showSender: Bool = true) {
        self.chatMessage = chatMessage
        self.showTimestamp = showTimestamp
        self.showSender = showSender
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if showSender {
                Text(chatMessage.sender)
                    .font(.callout)
                    .foregroundColor(.black)
            }
            
            HStack(alignment: .bottom) {
                Text(chatMessage.content)
                    .padding(.horizontal)
                    .padding(.vertical, 7)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                if showTimestamp {
                    Text(chatMessage.timestamp, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 1)
    }
}

#Preview {
    VStack {
        // 이름과 시간 모두 표시
        MessageBubble(
            chatMessage: ChatMessage(
                messageType: .message,
                id: 1,
                sender: "Alice",
                content: "안녕하세요!",
                roomId: 1,
                timestamp: Date()
            ),
            showTimestamp: true,
            showSender: true
        )
        
        // 이름만 숨김
        MessageBubble(
            chatMessage: ChatMessage(
                messageType: .message,
                id: 2,
                sender: "Alice",
                content: "오늘 날씨가 좋네요!",
                roomId: 1,
                timestamp: Date()
            ),
            showTimestamp: true,
            showSender: false
        )
        
        // 시간만 숨김
        MessageBubble(
            chatMessage: ChatMessage(
                messageType: .message,
                id: 3,
                sender: "Bob",
                content: "네, 정말 좋네요!",
                roomId: 1,
                timestamp: Date()
            ),
            showTimestamp: false,
            showSender: true
        )
        
        // 이름과 시간 모두 숨김
        MessageBubble(
            chatMessage: ChatMessage(
                messageType: .message,
                id: 4,
                sender: "Bob",
                content: "산책하기 좋은 날이에요.",
                roomId: 1,
                timestamp: Date()
            ),
            showTimestamp: false,
            showSender: false
        )
    }
    .padding()
}
