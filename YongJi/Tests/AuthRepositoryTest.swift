import XCTest
import RxSwift
@testable import YongJiBus

final class AuthRepositoryTests: XCTestCase {
    
    var sut: AuthRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        sut = AuthRepository.shared
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        sut = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func test_sendAuthEmail_성공() {
        // given
        let expectation = XCTestExpectation(description: "이메일 인증 코드 전송")
        let testEmail = "test@example.com"
        
        // when
        sut.sendAuthEmail(email: testEmail)
            .subscribe(
                onSuccess: { response in
                    // then
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                },
                onFailure: { error in
                    XCTFail("Expected success but got error: \(error)")
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_verifyAuthCode_성공() {
        // given
        let expectation = XCTestExpectation(description: "인증 코드 확인")
        let testEmail = "test@example.com"
        let testCode = "123456"
        
        // when
        sut.verifyAuthCode(email: testEmail, code: testCode)
            .subscribe(
                onSuccess: { response in
                    // then
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                },
                onFailure: { error in
                    XCTFail("Expected success but got error: \(error)")
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_signup_성공() {
        // given
        let expectation = XCTestExpectation(description: "회원가입")
        let testEmail = "test@example.com"
        let testPassword = "password123"
        let testName = "Test User"
        let testUsername = "testuser"
        
        // when
        sut.signup(email: testEmail, password: testPassword, name: testName, username: testUsername)
            .subscribe(
                onSuccess: { response in
                    // then
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                },
                onFailure: { error in
                    XCTFail("Expected success but got error: \(error)")
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_login_성공() {
        // given
        let expectation = XCTestExpectation(description: "로그인")
        let testEmail = "test@example.com"
        let testPassword = "password123"
        
        // when
        sut.login(email: testEmail, password: testPassword)
            .subscribe(
                onSuccess: { response in
                    // then
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                },
                onFailure: { error in
                    XCTFail("Expected success but got error: \(error)")
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
}