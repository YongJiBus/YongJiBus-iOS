import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                //Title
                HStack {
                    Text("회원 가입")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .disabled(viewModel.isLoading)
                }
                
                //Content            
                switch viewModel.currentStep {
                case 1:
                    emailInputSection
                    if viewModel.isEmailFilled {
                        authCodeInputSection
                    }
                case 2:
                    registerInfoSection
                case 3:
                    registerInfoSection
                default:
                    EmptyView()
                }
                
                //BottomButton
                Spacer() 

                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.moveToNextStep()
                    }
                } label: {
                    Text(viewModel.currentStep != 3 ? "다음" : "가입하기")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,10)
                        .background(viewModel.isStepValid() ? Color("RowNumColor") : Color("RowNumColor").opacity(0.5))
                        .cornerRadius(18)
                }
                .disabled(!viewModel.isStepValid() || viewModel.isLoading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .blur(radius: viewModel.isLoading ? 3 : 0)
            .allowsHitTesting(!viewModel.isLoading)
            
            // 로딩 오버레이
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.isSignUpFinished) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
        .onAppear {
            AnalyticsManager.shared.logScreenView(
                screenName: "SignUpView",
                screenClass: "SignUpView"
            )
        }
    }
    
    // 로딩 오버레이 뷰
    private var loadingOverlay: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color("RowNumColor"))
            
            Text("처리 중...")
                .font(.headline)
                .foregroundColor(Color("RowNumColor"))
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        )
        .transition(.opacity)
    }
    
    // 두 번째 단계의 회원가입 정보 입력 섹션
    private var registerInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 이름 입력
            VStack(alignment: .leading, spacing: 8) {
                Text("이름")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                TextField("이름을 입력하세요", text: $viewModel.name)
                    .coloredBackGround()
                    .onChange(of: viewModel.name) { oldValue, newValue in
                        viewModel.validateAndUpdateName(newValue)
                    }
            }
            
            // 닉네임 입력
            VStack(alignment: .leading, spacing: 8) {
                Text("닉네임")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                HStack(spacing: 12){
                    TextField("닉네임을 입력하세요", text: $viewModel.nickname)
                        .coloredBackGround()
                        .onChange(of: viewModel.nickname) { oldValue, newValue in
                            viewModel.validateAndUpdateNickname(newValue)
                        }
                    
                    SmallButton(title: "인증", isEnabled: viewModel.nickname.count >= 2 && !viewModel.isNickNameNotDuplicated && !viewModel.isLoading) {
                        viewModel.verifyNickName()
                    }
                }
            }
            
            if viewModel.currentStep == 3 {
                // 비밀번호 입력
                VStack(alignment: .leading, spacing: 8) {
                    Text("비밀번호")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    SecureField("비밀번호를 입력하세요", text: $viewModel.password)
                        .coloredBackGround()
                        .onChange(of: viewModel.password) { oldValue, newValue in
                            viewModel.validateAndUpdatePassword(newValue)
                        }
                    
                }
                
                // 비밀번호 확인
                VStack(alignment: .leading, spacing: 8) {
                    Text("비밀번호 확인")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    SecureField("비밀번호를 다시 입력하세요", text: $viewModel.passwordConfirm)
                        .coloredBackGround()
                        .onChange(of: viewModel.passwordConfirm) { oldValue, newValue in
                            viewModel.validateAndUpdatePasswordConfirm(newValue)
                        }
                    
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    
    private var authCodeInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("인증번호")
                .font(.system(size: 18))
                .fontWeight(.medium)
            
            HStack(spacing: 12) {
                TextField("인증번호를 입력하세요", text: $viewModel.authCode)
                    .coloredBackGround()
                    .onChange(of: viewModel.authCode) { oldValue, newValue in
                        viewModel.validateAndUpdateAuthCode(newValue)
                    }

                SmallButton(title: "인증", isEnabled: viewModel.authCode.count == 6 && !viewModel.isEmailVerified && !viewModel.isLoading) {
                    viewModel.verifyAuthCode()
                }
            }

            if viewModel.isEmailVerified {
                Text("인증번호가 확인되었습니다.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var emailInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이메일")
                .font(.system(size: 18))
                .fontWeight(.medium)
            
            HStack(spacing: 12) {
                TextField("@mju.ac.kr", text: $viewModel.email)
                    .coloredBackGround()
                    .keyboardType(.emailAddress)
                    .onChange(of: viewModel.email) { oldValue, newValue in
                        viewModel.validateAndUpdateEmail(newValue)
                    }
                
                SmallButton(
                    title: "인증번호 전송",
                    isEnabled: viewModel.isEmailValid && !viewModel.isLoading
                ) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.verifyEmail()
                    }
                }
            }
            
            if viewModel.isEmailFilled {
                Text("인증번호가 이메일로 전송되었습니다.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
