//
//  ChattingListView.swift
//  YongJiBus
//
//  Created by bryan on 9/13/24.
//

import SwiftUI

struct ChattingListView: View {
    @StateObject private var viewModel = ChattingListViewModel()
    @State private var showingCreateChatSheet = false
    @State private var newChatName = ""
    @State private var departureDate = Date.now
    @State private var isCreatingChat = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.chatRooms, id: \.name) { chatRoom in
                        NavigationLink(destination: ChatRoomView(chatRoom: chatRoom)) {
                            ChatListCell(chatRoom: chatRoom)
                        }
                    }
                    
                    // 로딩 상태 표시
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $showingCreateChatSheet) {
                createChatRoomView
            }
            .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("확인") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .onAppear {
                viewModel.fetchChatRooms()
            }
            .refreshable {
                viewModel.fetchChatRooms()
            }
            .overlay(
                Button(action: {
                    showingCreateChatSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(25),
                alignment: .bottomTrailing
            )
        }
    }
    
    private var createChatRoomView: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 상단 헤더 영역
                VStack(alignment: .leading, spacing: 8) {
                    Text("새로운 채팅방 만들기")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("함께 이동할 친구들과 대화할 채팅방을 만들어보세요")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                
                VStack(spacing: 24) {
                    // 채팅방 이름 입력 필드
                    VStack(alignment: .leading, spacing: 8) {
                        Text("채팅방 이름")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("예: 기흥역에서 명진당", text: $newChatName)
                            .coloredBackGround()
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // 출발 시간 선택
                    VStack(alignment: .leading, spacing: 8) {
                        Text("출발 시간")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        DatePicker("", selection: $departureDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("RowColor"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // 생성 버튼
                    Button(action: createChatRoom) {
                        HStack {
                            Spacer()
                            if isCreatingChat {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .foregroundColor(.white)
                            } else {
                                Text("채팅방 생성하기")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(newChatName.isEmpty ? Color("RowNumColor").opacity(0.4) : Color("RowNumColor").opacity(0.9))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    .disabled(newChatName.isEmpty || isCreatingChat)
                    .padding(.bottom, 30)
                }
                .padding(.top, 20)
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                showingCreateChatSheet = false
            }) {
                Text("취소")
                    .fontWeight(.medium)
                    .foregroundColor(Color("RowNumColor").opacity(0.9))
            }
            )
        }
    }
}

extension ChattingListView {
    private func createChatRoom() {
        isCreatingChat = true
        
        // 날짜를 HH:mm 형식의 문자열로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let departureTimeString = formatter.string(from: departureDate)
        
        viewModel.createChatRoom(name: newChatName, departureTime: departureTimeString) { result in
            isCreatingChat = false
            
            switch result {
            case .success(_):
                // 채팅방 생성 성공 시 시트를 닫고 목록을 새로고침
                showingCreateChatSheet = false
                newChatName = ""
                departureDate = .now
                viewModel.fetchChatRooms()
                
            case .failure(_): break
                // 에러 처리는 ViewModel에서 이미 처리됨
            }
        }
    }
}

#Preview {
    ChattingListView()
}
