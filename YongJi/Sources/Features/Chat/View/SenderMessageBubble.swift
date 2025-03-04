import SwiftUI

struct SenderMessageBubble: View {
    let chatMessage: ChatMessage

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack {
                Spacer()
                Text(chatMessage.sender)
                    .font(.callout)
                    .foregroundColor(.black)
            }
            
            HStack(alignment: .bottom) {
                Text(chatMessage.timestamp, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.trailing, 5)
                
                Text(chatMessage.content)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SenderMessageBubble(chatMessage: ChatMessage(id: 2, sender: "Me", content: "Hi there!", roomId: 1, timestamp: Date()))
}
