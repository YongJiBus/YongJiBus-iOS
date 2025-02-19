import SwiftUI

struct MessageBubble: View {
    let chatMessage: ChatMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(chatMessage.sender)
                    .font(.callout)
                    .foregroundColor(.black)
                Spacer()
            }
            
            HStack(alignment: .bottom) {
                Text(chatMessage.message)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(chatMessage.timestamp, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MessageBubble(chatMessage: ChatMessage(id: 1, sender: "Alice", message: "Hello!sadfsdfesfwefwefsffssdfsdfsdfsdfsdafsdfsadfsdfdfasdf", timestamp: Date()))
}
