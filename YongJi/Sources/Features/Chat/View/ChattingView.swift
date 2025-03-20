import SwiftUI
import RxSwift

struct ChattingView: View {
    let chatRoom: ChatRoom
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel : ChatViewModel
    
    @State private var newMessage: String = ""
    @State private var reportReason: String = ""
    @State private var isMenuShowing: Bool = false
    @State private var showLeaveAlert: Bool = false
    
    init(chatRoom : ChatRoom){
        self.chatRoom = chatRoom
        self.viewModel = ChatViewModel(chatRoom: chatRoom)
    }

    var body: some View {
        VStack {
            ChatMessageListView(viewModel: viewModel, chatRoom: chatRoom)
            //채팅 UI
            ChattingTextField
        }
        .onDisappear{
            viewModel.unsetActiveRoom()
        }
        .navigationTitle(chatRoom.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showLeaveAlert = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
        }
        .alert("채팅방 나가기", isPresented: $showLeaveAlert) {
            Button("취소", role: .cancel) {}
            Button("나가기", role: .destructive) {
                self.dismiss()
                viewModel.leaveChat()
            }
        } message: {
            Text("정말 이 채팅방을 나가시겠습니까? 모든 대화 내용이 삭제됩니다.")
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
        .alert("메시지 신고", isPresented: $viewModel.showReportAlert, actions: {
            TextField("신고 사유를 입력해주세요", text: $reportReason)
            
            Button("취소", role: .cancel) {
                reportReason = ""
                viewModel.messageToReport = nil
            }
            
            Button("신고하기", role: .destructive) {
                if let message = viewModel.messageToReport {
                    viewModel.reportMessage(message: message, reason: reportReason)
                }
                reportReason = ""
            }
        }, message: {
            Text("이 메시지를 신고하는 이유를 알려주세요.")
        })
        .overlay {
            if viewModel.isReporting {
                ProgressView("신고 처리 중...")
                    .padding()
                    .background(Color(.systemBackground).opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            
            if viewModel.reportSuccess {
                Text("신고가 접수되었습니다")
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
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
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        viewModel.sendMessage(roomId: chatRoom.id, content: newMessage)
        newMessage = ""
    }
}

#Preview {
    //ChattingView(chatRoom: ChatRoom(id: 1, name: "기흥역 가시죠", departureTime: "12:30" , members: 3))
}
