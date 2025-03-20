import Foundation
import RxSwift


class SignUpViewModel: ObservableObject , AuthViewModel{
    private let authRepository = AuthRepository.shared
    private let userManager = UserManager.shared
    private let disposeBag = DisposeBag()
    
    @Published var email: String = ""
    @Published var authCode: String = ""
    @Published var isEmailFilled = false
    @Published var isEmailVerified = false
    @Published var currentStep = 1
    @Published var name: String = ""
    @Published var nickname: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var isNickNameNotDuplicated = false
    @Published var errorMessage : String?
    @Published var isSignUpFinished = false
    @Published var isLoading = false
    
    var isStep1Valid: Bool {
        return isEmailVerified
    }
    
    var isStep2Valid: Bool {
        return !name.isEmpty && !nickname.isEmpty && isNickNameNotDuplicated
    }
    
    var isStep3Valid: Bool {
        return !password.isEmpty && !passwordConfirm.isEmpty && isStep2Valid && password == passwordConfirm
    }
    
    var isEmailValid: Bool {
        return !email.isEmpty && email.hasSuffix("@mju.ac.kr") && email.count > "@mju.ac.kr".count && !isEmailFilled
    }
    
    func isStepValid() -> Bool {
        switch currentStep {
        case 1:
            return isStep1Valid
        case 2:
            return isStep2Valid
        case 3:
            return isStep3Valid
        default:
            return false
        }
    }
    
    func moveToNextStep() {
        if currentStep == 1 && isStep1Valid {
            currentStep = 2
        } else if currentStep == 2 && isStep2Valid {
            currentStep = 3
        } else if currentStep == 3 && isStep3Valid {
            self.signUp()
        }
    }
    
    func validateAndUpdateEmail(_ newValue: String) {
        if newValue.count > 30 {
            email = String(newValue.prefix(30))
        } else {
            email = newValue
        }
    }
    
    func validateAndUpdateAuthCode(_ newValue: String) {
        if newValue.count > 6 {
            authCode = String(newValue.prefix(6))
        } else {
            authCode = newValue
        }
    }
    
    func validateAndUpdateName(_ newValue: String) {
        if newValue.count > 10 {
            name = String(newValue.prefix(10))
        } else {
            name = newValue
        }
    }
    
    func validateAndUpdateNickname(_ newValue: String) {
        if newValue.count > 10 {
            nickname = String(newValue.prefix(10))
        } else {
            nickname = newValue
        }
    }
    
    func validateAndUpdatePassword(_ newValue: String) {
        if newValue.count > 20 {
            password = String(newValue.prefix(20))
        } else {
            password = newValue
        }
    }
    
    func validateAndUpdatePasswordConfirm(_ newValue: String) {
        if newValue.count > 20 {
            passwordConfirm = String(newValue.prefix(20))
        } else {
            passwordConfirm = newValue
        }
    }
    
    func verifyEmail() {
        guard isEmailValid else { return }
        
        isLoading = true
        
        authRepository.sendAuthEmail(email: email)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.isEmailFilled = true
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.errorMessage = "인증번호 발송에 실패하였습니다\n다시시도해주세요"
                }
            )
            .disposed(by: disposeBag)
    }
    
    func verifyAuthCode() {
        guard authCode.count == 6 else { return }
        
        isLoading = true
        
        authRepository.verifyAuthCode(email: email, code: authCode)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.isEmailVerified = true
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.errorMessage = "인증에 실패하였습니다\n다시시도해주세요"
                }
            )
            .disposed(by: disposeBag)
    }
    
    func verifyNickName() {
        guard nickname.count >= 2 else { return }
        
        isLoading = true
        
        authRepository.checkUsernameExists(username: nickname)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    self.isLoading = false
                    if response.exists {
                        self.errorMessage = "이미 사용 중인 닉네임입니다"
                        self.isNickNameNotDuplicated = false
                    } else {
                        self.isNickNameNotDuplicated = true
                    }
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.errorMessage = "닉네임 확인에 실패하였습니다\n다시시도해주세요"
                    self.isNickNameNotDuplicated = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func signUp() {
        guard isStep3Valid else { return }
        
        isLoading = true
        
        authRepository.signup(
            email: email,
            password: password,
            name: name,
            username: nickname
        )
        .observe(on: MainScheduler.instance)
        .subscribe(
            onSuccess: { [weak self] token in
                guard let self = self else { return }
                
                do {
                    try self.saveAuthToken(token: token)
                    
                    // Save user information
                    self.userManager.saveUser(
                        email: self.email,
                        name: self.name,
                        nickname: self.nickname
                    )
                    self.registerFCMToken()

                } catch {
                    self.isLoading = false
                    self.errorMessage = "토큰 저장에 실패하였습니다\n다시시도해주세요"
                }
                
            },
            onFailure: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = "회원가입에 실패하였습니다\n다시시도해주세요"
            }
        )
        .disposed(by: disposeBag)
    }
    
    func registerFCMToken(){
        let token = SecureDataManager.shared.getData(label: .fcmToken)
        
        ChatRepository.shared.registerFCMToken(token: token)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.isLoading = false
                self.isSignUpFinished = true
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = "등록 오류 다시 가입해주세요"
            }
            .disposed(by: disposeBag)
    }
}
