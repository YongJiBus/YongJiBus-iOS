import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingSignUp = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                // Title
                HStack {
                    Text("로그인")
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
                }
                
                // Login Form
                VStack(alignment: .leading, spacing: 16) {
                    // Email Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("이메일")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        TextField("@mju.ac.kr", text: $viewModel.email)
                            .coloredBackGround()
                            .keyboardType(.emailAddress)
                            .onChange(of: viewModel.email) { oldValue, newValue in
                                viewModel.validateEmail(newValue)
                            }
                    }
                    
                    // Password Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("비밀번호")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        SecureField("비밀번호를 입력하세요", text: $viewModel.password)
                            .coloredBackGround()
                            .onChange(of: viewModel.password) { oldValue, newValue in
                                viewModel.validatePassword(newValue)
                            }
                    }
                }
                .padding(.horizontal, 20)
                
                // Login Button
                Spacer()
                VStack(spacing: 16) {
                    Button {
                        viewModel.login()
                    } label: {
                        Text("로그인")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(viewModel.isFormValid ? Color("RowNumColor") : Color("RowNumColor").opacity(0.5))
                            .cornerRadius(18)
                    }
                    .disabled(!viewModel.isFormValid)
                    
                    // Sign Up Button
                    Button {
                        showingSignUp = true
                    } label: {
                        Text("계정이 없으신가요? 회원가입")
                            .font(.subheadline)
                            .foregroundColor(Color("RowNumColor"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .fullScreenCover(isPresented: $showingSignUp) {
            SignUpView()
                .onDisappear {
                    if UserManager.shared.isUser {
                        dismiss()
                    }
                }
        }
        .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.isFinished) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
