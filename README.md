# YongJiBus (용지버스) - 명지대학교 셔틀버스 앱

## 프로젝트 소개

용지버스는 명지대학교 자연 캠퍼스(용인) 학생들이 셔틀버스 시간표를 쉽게 확인할 수 있는 iOS 애플리케이션입니다. 학교 홈페이지를 여러 번 탐색해야 하는 불편함을 해소하고, 직관적인 인터페이스로 셔틀 시간을 빠르게 확인할 수 있습니다.

## 주요 기능

### 1. 셔틀버스 시간표 조회
- **명지대역 셔틀**: 명지대역과 캠퍼스 간 셔틀버스 시간표 제공
- **기흥역 셔틀**: 기흥역과 캠퍼스 간 셔틀버스 시간표 제공
- **주말/공휴일 모드**: 평일/주말 시간표 자동 전환 기능
- **실시간 도착 정보**: 진입로 빨간버스 도착 예정 시간 표시

### 2. 택시 카풀 채팅
- 사용자 간 택시 카풀 채팅방 생성 및 참여
- 실시간 채팅 기능

### 3. 개인화 설정
- 평일/주말 모드 수동 및 자동 전환 설정
- 사용자 계정 관리

## 기술 스택

- **프레임워크**: SwiftUI, UIKit(부분적)
- **아키텍처**: MVVM(Model-View-ViewModel)
- **네트워킹**: Alamofire, RxSwift , Combine(부분적)
- **데이터 관리**: UserDefaults, JSON
- **인증**: Firebase Auth
- **실시간 통신**: WebSocket

## 프로젝트 구조

```
YongJi/
├── Sources/
│   ├── Features/          # 주요 기능별 모듈
│   │   ├── Auth/          # 사용자 인증 관련
│   │   ├── Chat/          # 택시 카풀 채팅 기능
│   │   ├── Shuttle/       # 셔틀버스 시간표 기능
│   │   ├── Station/       # 역 정보 관련 기능
│   │   ├── Settings/      # 앱 설정 기능
│   │   ├── WebSocket/     # 실시간 통신 관련
│   │   └── AppViewModel.swift
│   ├── Common/            # 공통 컴포넌트 및 유틸리티
│   │   ├── Extension/     # Swift 확장 기능
│   │   ├── Global/        # 전역 상수 및 함수
│   │   ├── Model/         # 공통 데이터 모델
│   │   ├── DataManager/   # 데이터 관리 유틸리티
│   │   └── UI/            # 재사용 가능한 UI 컴포넌트
│   ├── Router/            # 앱 내 화면 라우팅
│   ├── Data/              # 정적 데이터 (JSON 등)
│   ├── YongJiBusApp.swift # 앱 진입점
│   └── ContentView.swift  # 메인 뷰
├── Resources/             # 이미지, 폰트 등 리소스
├── Support/               # 지원 파일
└── Tests/                 # 테스트 코드
```

## 주요 모듈 설명

### 1. Shuttle 모듈
- **Model**: 셔틀버스 시간 관련 데이터 모델
- **View**: 셔틀 시간표 표시 UI 컴포넌트
- **ViewModel**: 시간표 데이터 관리 및 비즈니스 로직
- **Repository**: 서버 API 통신 및 데이터 저장소

### 2. Chat 모듈
- **Model**: 채팅방 및 메시지 데이터 모델
- **View**: 채팅 인터페이스 UI 컴포넌트
- **ViewModel**: 채팅 데이터 관리 및 비즈니스 로직
- **Repository**: 채팅 서버 통신

### 3. Auth 모듈
- **Model**: 사용자 인증 관련 데이터 모델
- **View**: 로그인/회원가입 UI
- **ViewModel**: 인증 관련 비즈니스 로직
- **Repository**: 인증 서버 통신


## 각 기능별 뷰 구성

### 🔐 Auth (인증) 관련 뷰
- **LoginView**: 사용자 로그인 화면
- **SignUpView**: 회원가입 화면 
- **UserView**: 사용자 프로필 및 정보 화면

### 💬 Chat (채팅) 관련 뷰
- **ChattingListView**: 채팅방 목록 화면
- **ChattingView**: 개별 채팅방 화면
- **ChatMessageListView**: 메시지 목록 표시 컴포넌트 (UIKit으로 만든 뷰를 SwiftUI로 변환한 뷰)
- **ChatMessageListController**: 채팅 메시지 컨트롤러 (UIKit 및 Combine 사용 : ViewModel의 @Pusblished 데이터 사용하기 위해) 
- **MessageCell**: 메시지 셀 컴포넌트
- **ChatListCell**: 채팅방 목록 셀 컴포넌트
- **MessageBubble**: 메시지 말풍선 컴포넌트
- **SenderMessageBubble**: 발신자 메시지 말풍선 컴포넌트

### 🚌 Shuttle (셔틀) 관련 뷰
- **ShuttleView**: 메인 셔틀 정보 화면
- **ShuttleInfoView**: 셔틀 상세 정보 화면
- **ShuttleTimeView**: 셔틀 시간 표시 화면
- **ShuttleRow**: 셔틀 시간표 행 컴포넌트
- **BusBoxView**: 버스 정보 박스 컴포넌트

### 🚉 Station (역) 관련 뷰
- **StationView**: 기흥역 및 명지대역 셔틀 정보 화면
- **GiheungInfoView**: 기흥역 셔틀 정보 화면
- **StationTimeRow**: 역 시간표 행 컴포넌트

### ⚙️ Settings (설정) 관련 뷰
- **SettingView**: 앱 설정 화면 (평일/주말 모드, 알림 설정 등)

## 개발 환경 설정

1. Xcode 14.0 이상 설치
2. Tuist 4.0 설치
   ```
   curl -Ls https://install.tuist.io | bash
   tuist install 4.0.0
   ```
3. 프로젝트 클론
   ```
   git clone https://github.com/your-username/YongJiBus.git
   ```
4. 프로젝트 생성 (Tuist 사용)
   ```
   cd YongJiBus
   tuist generate
   ```
5. 빌드 및 실행

> **참고**: 이 프로젝트는 Tuist 4.0을 사용하여 의존성 관리와 프로젝트 설정을 코드로 관리합니다. Tuist에 대한 자세한 정보는 [공식 문서](https://docs.tuist.io/)를 참조하세요.
