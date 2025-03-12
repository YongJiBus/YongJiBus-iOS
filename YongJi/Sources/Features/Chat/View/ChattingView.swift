import SwiftUI

struct ChattingView: View {
    let chatRoom: ChatRoom
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChatViewModel()
    
    @State private var newMessage: String = ""
    @State private var scrollPosition: Int64? = 0
    @State private var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack{
                        ForEach(viewModel.messages) { chatMessage in
                            if isMyMessage(chatMessage) {
                                SenderMessageBubble(chatMessage: chatMessage)
                                    .padding(.vertical,0)
                                    .listRowSeparator(.hidden)
                                    .id(chatMessage.id)
                            } else {
                                MessageBubble(chatMessage: chatMessage)
                                    .padding(.vertical, 0)
                                    .listRowSeparator(.hidden)
                                    .id(chatMessage.id)
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal)
                }
                .scrollPosition(id: $scrollPosition, anchor: .bottom)
                .overlay(content: {
                    Text("\(self.scrollPosition!)")
                })
                // 새로운 메시지 알림있을 때 확인하면 제거
                .onChange(of: scrollPosition, { _, newValue in
                    if newValue == viewModel.messages.last?.id {
                        viewModel.dismissNewMessageBanner()
                    }
                })
                .onChange(of: viewModel.messages, { _, messages in
                    if let lastMessage = messages.last {
                        if isMyMessage(lastMessage) || scrollPosition! == lastMessage.id - 1 {
                            withAnimation {
                                scrollPosition = lastMessage.id
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        } else {
                            viewModel.showNewMessageBanner = true
                        }
                    }
                })
                .onAppear {
                    self.scrollProxy = proxy
                    if let lastId = viewModel.messages.last?.id {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
                
                if viewModel.showNewMessageBanner {
                    NewMessageBar
                }
            }
            
            //채팅 UI
            ChattingTextField
        }
        .navigationTitle(chatRoom.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            connectToChat()
        }
        .onDisappear {
            print("ChattingView Disappera")
            viewModel.unsetActiveRoom()
            //viewModel.disconnect()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("오류"),
                message: Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다."),
                dismissButton: .default(Text("확인")) {
                    self.dismiss()
                }
            )
        }
    }
    
    private var NewMessageBar : some View {
        Button(action: {
            withAnimation {
                scrollProxy?.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                viewModel.dismissNewMessageBanner()
                self.scrollPosition = viewModel.messages.last?.id
            }
        }) {
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                Text("새 메시지가 있습니다")
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
    
    private var ChattingTextField : some View {
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
            .disabled(newMessage.isEmpty && newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(newMessage.isEmpty ? 0.5 : 1.0)
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}

extension ChattingView {
    
    private func isMyMessage(_ message: ChatMessage) -> Bool {
        return message.sender == UserManager.shared.currentUser?.nickname
    }
    
    private func connectToChat() {
        viewModel.connectWebSocket()
        viewModel.subscribeToRoom(roomId: chatRoom.id)
        viewModel.getChatMessages(roomId: chatRoom.id)
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        viewModel.sendMessage(roomId: chatRoom.id, content: newMessage)
        newMessage = ""
    }
}

#Preview {
    ChattingView(chatRoom: ChatRoom(id: 1, name: "기흥역 가시죠", departureTime: "12:30" , members: 3))
}
