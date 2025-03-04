import SwiftUI

struct ChatRoomView: View {
    let chatRoom: ChatRoom
    @StateObject private var viewModel = ChatViewModel()
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            List(viewModel.messages) { chatMessage in
                if isMyMessage(chatMessage){
                    SenderMessageBubble(chatMessage: chatMessage)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, -10)
                } else {
                    MessageBubble(chatMessage: chatMessage)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, -10)
                }

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
        .onAppear {
            connectToChat()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
    private func isMyMessage(_ message: ChatMessage) -> Bool {
        return message.sender == "테스트"
    }
    
    private func connectToChat() {
        viewModel.connectWebSocket()
        // 채팅방 구독
        viewModel.subscribeToRoom(roomId: chatRoom.id)
        viewModel.getChatMessages(roomId: chatRoom.id)
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        viewModel.sendMessage(roomId: chatRoom.id, content: newMessage)
        newMessage = "" // 입력 필드 초기화
    }
}

#Preview {
    ChatRoomView(chatRoom: ChatRoom(id: 1, name: "기흥역 가시죠", departureTime: "12:30" , members: 3))
}
