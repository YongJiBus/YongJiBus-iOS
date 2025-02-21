import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var authCode: String = ""
    @State private var isEmailFilled = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack{
                Text("회원 가입")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                Spacer()
            }
            // 이메일 입력 섹션
            VStack(alignment: .leading, spacing: 8) {
                Text("이메일")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                HStack(spacing: 12) {
                    ColoredTextField(
                        placeholder: "example@mju.ac.kr",
                        text: $email,
                        keyboardType: .emailAddress
                    )
                    SmallButton(
                        title: "인증번호 전송",
                        isEnabled: !email.isEmpty && email.hasSuffix("@mju.ac.kr") && email.count > "@mju.ac.kr".count
                    ) {
                        withAnimation(.easeIn(duration: 0.3)){
                            isEmailFilled.toggle()
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, !isEmailFilled ? 40 : 0)
            
            if isEmailFilled {
                VStack(alignment: .leading, spacing: 8) {
                    Text("인증번호")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    HStack(spacing: 12) {
                        ColoredTextField(placeholder: "인증번호를 입력하세요.", text: $authCode, maxLength: 6)
                        SmallButton(title: "인증", isEnabled: authCode.count == 6) {
                            
                        }
                    }
                }
                .padding(.horizontal, 20)
                .animation(.easeInOut(duration: 0.3), value: isEmailFilled)
            }
            
            Spacer()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
