import SwiftUI

struct ChatRoomView: View {
    let chatRoom: ChatRoom
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: 1, sender: "Alice", message: "Hello!", timestamp: Date()),
        ChatMessage(id: 2, sender: "Bob", message: "How are you?", timestamp: Date()),
        ChatMessage(id: 3, sender: "Alice", message: "Let's meet at the station.", timestamp: Date())
    ]
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            List(messages) { chatMessage in
                MessageBubble(chatMessage: chatMessage)
                    .listRowSeparator(.hidden)
                    .padding(.vertical, -10)
            }
            .listStyle(.plain)
            
            HStack {
                TextField("메시지를 입력하세요.", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Text("전송")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .disabled(newMessage.isEmpty)
                .opacity(newMessage.isEmpty ? 0.5 : 1.0) // Dim the button when disabled
            }
            .padding()
        }
        .navigationTitle(chatRoom.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let newChatMessage = ChatMessage(id: messages.count + 1, sender: "You", message: newMessage, timestamp: Date())
        messages.append(newChatMessage)
        newMessage = ""
    }
}

#Preview {
    ChatRoomView(chatRoom: ChatRoom(id: 1, name: "기흥역 가시죠", time: "10:00", members: 3))
}
