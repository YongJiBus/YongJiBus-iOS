//
//  ChattingListView.swift
//  YongJiBus
//
//  Created by bryan on 9/13/24.
//

import SwiftUI

struct ChattingListView: View {
    @StateObject private var viewModel: ChattingListViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showingCreateChatSheet = false
    @State private var newChatName = ""
    @State private var departureDate = Date.now
    @State private var isCreatingChat = false
    @State private var selectedChatRoom: ChatRoom?
    @State private var navigateToChat = false
    @State private var isShowingLoginModal = false
    @State private var selectedTab = 0 // 0: 내 채팅방, 1: 모든 채팅방
    @State private var isLogin: Bool = false
    // 기본 초기화 메서드
    init() {
        self._viewModel = StateObject(wrappedValue: ChattingListViewModel())
    }
    
    // 테스트용 ViewModel 주입 초기화 메서드
    init(viewModel: ChattingListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            if isLogin {
                VStack(spacing: 0) {
                    segmentedControlWithSwipe
                }
                .onAppear {
                    if isLogin {
                        fetchAppropriateRooms()
                    }
                }
                .refreshable {
                    fetchAppropriateRooms()
                }
                .onChange(of: selectedTab) { _, _ in
                    fetchAppropriateRooms()
                }
                .overlay(createChatButton, alignment: .bottomTrailing)
            } else {
                //로그인을 안 했을 경우
                loginRequiredView
                    .padding()
            }
        }
        .onAppear{
            self.isLogin = appViewModel.isLogin
        }
        .navigationDestination(isPresented: $navigateToChat) {
            if let selectedRoom = selectedChatRoom {
                ChattingView(chatRoom: selectedRoom)
            }
         }
        .navigationDestination(isPresented: $appViewModel.shouldNavigateToChat) {
            if let selectedRoom = appViewModel.selectedChatRoom {
                ChattingView(chatRoom: selectedRoom)
                    .onDisappear {
                        fetchAppropriateRooms()
                        appViewModel.shouldNavigateToChat = false
                    }
            }
        }
        .sheet(isPresented: $showingCreateChatSheet) {
            createChatRoomView
        }
        .fullScreenCover(isPresented: $isShowingLoginModal) {
            LoginView()
                .onDisappear {
                    self.isLogin = appViewModel.isLogin
                    if appViewModel.isLogin {
                        fetchAppropriateRooms()
                    }
                }
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
    }
    
    private var loginRequiredView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // 이미지 아이콘
            Image(systemName: "bubble.left.and.bubble.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(Color("RowNumColor").opacity(0.7))
            
            // 안내 텍스트
            VStack(spacing: 8) {
                Text("채팅 기능을 이용하려면")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text("로그인이 필요합니다")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            
            // 부가 설명
            Text("용지버스 채팅을 통해 함께 이동할 사람들과\n실시간으로 대화를 나눠보세요.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            // 로그인 버튼
            Button(action: {
                isShowingLoginModal = true
            }) {
                HStack {
                    Spacer()
                    Text("로그인 하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color("RowNumColor").opacity(0.9))
                .cornerRadius(15)
                .padding(.horizontal, 40)
            }
            .padding(.top, 24)
            
            Spacer()
        }
    }
    
    private var createChatRoomView: some View {
        NavigationView {
            ZStack {  // ZStack으로 변경하여 전체 화면에 탭 제스처를 추가
                Color.clear  // 투명 배경으로 제스처 영역 확보
                    .contentShape(Rectangle())  // 투명해도 탭 가능하게 함
                    .onTapGesture {
                        // 키보드 숨기기
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
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
    
    // 내 채팅방이 없을 때 표시할 뷰
    private var emptyMyChatRoomView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "bubble.left.and.bubble.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray.opacity(0.5))
            
            Text("참여 중인 채팅방이 없습니다")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("새 채팅방을 만들거나 기존 채팅방에 참여해보세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(minHeight: 300)
    }
    
    // 커스텀 세그먼트 컨트롤 부분을 별도의 속성으로 분리
    private var segmentedControlWithSwipe: some View {
        VStack(spacing: 0) {
            // 기존 세그먼트 컨트롤 유지 (탭으로 전환 가능)
            HStack(spacing: 0) {
                // 내 채팅방 탭
                Button(action: {
                    selectedTab = 0
                }) {
                    VStack(spacing: 4) {
                        Text("내 채팅방")
                            .font(.headline)
                            .fontWeight(selectedTab == 0 ? .bold : .regular)
                            .foregroundColor(selectedTab == 0 ? Color("RowNumColor") : .gray)
                        
                        // 밑줄 애니메이션
                        Rectangle()
                            .fill(Color("RowNumColor"))
                            .frame(height: 3)
                            .opacity(selectedTab == 0 ? 1 : 0)
                            .scaleEffect(x: selectedTab == 0 ? 1 : 0.3, y: 1, anchor: .center)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                // 모든 채팅방 탭
                Button(action: {
                    selectedTab = 1
                }) {
                    VStack(spacing: 4) {
                        Text("모든 채팅방")
                            .font(.headline)
                            .fontWeight(selectedTab == 1 ? .bold : .regular)
                            .foregroundColor(selectedTab == 1 ? Color("RowNumColor") : .gray)
                        
                        // 밑줄 애니메이션
                        Rectangle()
                            .fill(Color("RowNumColor"))
                            .frame(height: 3)
                            .opacity(selectedTab == 1 ? 1 : 0)
                            .scaleEffect(x: selectedTab == 1 ? 1 : 0.3, y: 1, anchor: .center)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 8)
            .padding(.bottom, 4)
            .background(Color(.systemBackground))
            
            // 스와이프 가능한 TabView
            TabView(selection: $selectedTab) {
                // 내 채팅방 뷰
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.myChatRooms) { chatRoom in
                            ChatListCell(chatRoom: chatRoom)
                                .onTapGesture {
                                    joinAndNavigate(to: chatRoom)
                                }
                        }
                        
                        // 내 채팅방이 없는 경우 안내 메시지
                        if viewModel.myChatRooms.isEmpty {
                            emptyMyChatRoomView
                        }
                    }
                    .padding(.horizontal)
                }
                .tag(0)
                
                // 모든 채팅방 뷰
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.allChatRooms) { chatRoom in
                            ChatListCell(chatRoom: chatRoom)
                                .onTapGesture {
                                    joinAndNavigate(to: chatRoom)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
    }
    
    // 채팅방 생성 버튼
    private var createChatButton: some View {
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
        .padding(25)
    }
}

extension ChattingListView {
    
    private func fetchAppropriateRooms() {
        if selectedTab == 0 {
            viewModel.fetchMyChatRooms()
        } else {
            viewModel.fetchAllChatRooms()
        }
    }
    

    private func joinAndNavigate(to chatRoom: ChatRoom) {
        viewModel.joinChatRoom(roomId: chatRoom.id) { result in
            switch result {
            case .success:
                self.selectedChatRoom = chatRoom
                self.navigateToChat = true
            case .failure:
                // 에러 처리는 ViewModel에서 처리됨
                break
            }
        }
    }

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
                fetchAppropriateRooms()
                
            case .failure(_): break
                // 에러 처리는 ViewModel에서 이미 처리됨
            }
        }
    }
}

// 테스트용 Mock 데이터를 사용한 프리뷰
#Preview("Mock 데이터") {
    // MockAppViewModel 사용 - 항상 로그인 상태임
    let mockAppViewModel = AppViewModel()
    
    return ChattingListView(viewModel: MockChattingListViewModel())
        .environmentObject(mockAppViewModel)
}
