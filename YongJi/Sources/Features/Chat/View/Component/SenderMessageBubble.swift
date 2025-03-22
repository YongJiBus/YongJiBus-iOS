import SwiftUI

struct SenderMessageBubble: View {
    let chatMessage: ChatMessage
    let showTimestamp: Bool
    
    init(chatMessage: ChatMessage, showTimestamp: Bool = true) {
        self.chatMessage = chatMessage
        self.showTimestamp = showTimestamp
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack(alignment: .bottom) {
                Spacer()
                
                if showTimestamp {
                    Text(chatMessage.timestamp, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.trailing, 5)
                }
                
                Text(chatMessage.content)
                    .padding(.horizontal)
                    .padding(.vertical, 7)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 1)
    }
}

#Preview {
    SenderMessageBubble(chatMessage: ChatMessage(messageType: .message, id: 2, sender: "Me", content: "Hi there!", roomId: 1, timestamp: Date()))
}
