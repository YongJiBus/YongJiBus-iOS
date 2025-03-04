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
    
    var isStep1Valid: Bool {
        return isEmailVerified
    }
    
    var isStep2Valid: Bool {
        return !name.isEmpty && !nickname.isEmpty
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
        
        authRepository.sendAuthEmail(email: email)
            .subscribe(
                onSuccess: { [weak self] _ in
                    self?.isEmailFilled = true
                },
                onFailure: { [weak self] error in
                    self?.errorMessage = "인증번호 발송에 실패하였습니다\n다시시도해주세요"
                }
            )
            .disposed(by: disposeBag)
    }
    
    func verifyAuthCode() {
        guard authCode.count == 6 else { return }
        
        authRepository.verifyAuthCode(email: email, code: authCode)
            .subscribe(
                onSuccess: { [weak self] _ in
                    self?.isEmailVerified = true
                },
                onFailure: { [weak self] error in
                    self?.errorMessage = "인증에 실패하였습니다\n다시시도해주세요"
                }
            )
            .disposed(by: disposeBag)
    }
    
    func verifyNickName() {
        isNickNameNotDuplicated = true
    }
    
    func signUp() {
        guard isStep3Valid else { return }
        
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
                    
                    self.isSignUpFinished = true
                } catch {
                    self.errorMessage = "토큰 저장에 실패하였습니다\n다시시도해주세요"
                }
                
            },
            onFailure: { [weak self] error in
                self?.errorMessage = "회원가입에 실패하였습니다\n다시시도해주세요"
            }
        )
        .disposed(by: disposeBag)
    }
}
