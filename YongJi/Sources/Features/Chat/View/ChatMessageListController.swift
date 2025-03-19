//
//  ChatMessageListController.swift
//  YongJiBus
//
//  Created by 김도경 on 3/17/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

final class ChatMessageListController: UIViewController{
    
    private let chatRoom: ChatRoom
    private let viewModel: ChatViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var lastScrollPosition : Int64?
    
    init(viewModel: ChatViewModel,chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpChatListener()
        connectToChat()
    }
    
    private let cellIdentifier = "ChattingCell"
    
    private lazy var pullToRefresh: UIRefreshControl = {
        let pullToRefresh = UIRefreshControl()
        pullToRefresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return pullToRefresh
    }()
    
    private let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
        var listConfing = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfing.showsSeparators = false
        let section = NSCollectionLayoutSection.list(using: listConfing, layoutEnvironment: layoutEnvironment)
        section.contentInsets.leading = 0
        section.contentInsets.trailing = 0
        section.interGroupSpacing = -5
        return section
    }
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.selfSizingInvalidation = .enabledIncludingConstraints
        cv.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        cv.keyboardDismissMode = .onDrag
        cv.backgroundColor = .clear
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.refreshControl = pullToRefresh
        return cv
    }()
    
    private let pullDownButton : UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .black)
    
        let image = UIImage(systemName: "arrow.down.circle.fill", withConfiguration: imageConfig)
        buttonConfig.image = image
        buttonConfig.baseBackgroundColor = UIColor(named: "RowColor")
        buttonConfig.baseForegroundColor = UIColor(named: "RowNumColor")
        buttonConfig.imagePadding = 5
        buttonConfig.cornerStyle = .capsule
        let font = UIFont.systemFont(ofSize: 12,weight: .black)
        buttonConfig.attributedTitle = AttributedString("Pull Down", attributes: AttributeContainer([NSAttributedString.Key.font:font]))
        
        let button = UIButton(configuration: buttonConfig)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()

    private lazy var newMessageBar : UIView = {
        let view = UIHostingController(rootView: NewMessageBar(viewModel: viewModel))
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view.view
    }()
    
    private func setUpViews(){
        view.addSubview(collectionView)
        view.addSubview(pullDownButton)
        view.addSubview(newMessageBar)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pullDownButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            pullDownButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            newMessageBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            newMessageBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newMessageBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpChatListener(){
        let delay = 200
        viewModel.$messages
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink{ [weak self] messages in
                guard let self = self else { return }
                self.collectionView.reloadData()
                // 현재 마지막 메시지 저장
                if let lastMessage = messages.last, viewModel.lastMessage != messages.last {
                    if isMyMessage(messages.last!) || isScrolledToBottom(){
                        viewModel.shouldScrollToBottom = true
                    } else {
                        viewModel.showNewMessageBanner = true
                    }
                    viewModel.lastMessage = lastMessage
                }
            }.store(in: &subscriptions)

        
        viewModel.$shouldScrollToBottom
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink{ [weak self] shouldScrollToBottom in
                if shouldScrollToBottom {
                    self?.collectionView.scrollToLastItem(at: .bottom, animated: true)
                }
            }.store(in: &subscriptions)
        
        viewModel.$isLoadingMore
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink{ [weak self] isLoading in
                guard let self = self, let lastScrollPosition else {return}
                if isLoading == false {
                    guard let index = viewModel.messages.firstIndex(where:{ $0.id == lastScrollPosition }) else {return }
                    let indexPath = IndexPath(item: index, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                    self.pullToRefresh.endRefreshing()
                }
            }.store(in: &subscriptions)
        
        viewModel.$showNewMessageBanner
            .sink{ [weak self] showBanner in
                self?.newMessageBar.isHidden = !showBanner
                if !showBanner {
                    DispatchQueue.main.async{
                        self?.viewModel.shouldScrollToBottom = true
                    }
                }
            }.store(in: &subscriptions)
    }
    
    private func connectToChat(){
        viewModel.connectWebSocket()
        viewModel.subscribeToRoom(roomId: chatRoom.id)
        viewModel.getChatMessages(roomId: chatRoom.id)
    }
    
    @objc private func refreshData(){
        if viewModel.hasMoreMessages {
            lastScrollPosition = viewModel.messages.first?.id
            viewModel.loadMoreMessages()
        } else {
            pullToRefresh.endRefreshing()
        }
    }
}

extension ChatMessageListController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let index = indexPath.row
        let chatMessage = viewModel.messages[index]
        cell.contentConfiguration = UIHostingConfiguration{
            MessageCell(
                chatMessage: chatMessage,
                isMyMessage: isMyMessage(chatMessage),
                nextMessage: index < viewModel.messages.count - 1 ? viewModel.messages[index + 1] : nil,
                previousMessage: index > 0 ? viewModel.messages[index - 1] : nil,
                onReport: {
                    self.viewModel.messageToReport = chatMessage
                    self.viewModel.showReportAlert = true
                }
            )
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 && viewModel.hasMoreMessages{
            pullDownButton.alpha = 1.0
        } else {
            pullDownButton.alpha = 0
        }

        // 스크롤이 맨 아래에 도달했는지 확인
        let isAtBottom = scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 10)
        
        // 맨 아래로 스크롤했고 새 메시지 배너가 표시 중이면 배너 숨기기
        if isAtBottom && viewModel.showNewMessageBanner {
            viewModel.showNewMessageBanner = false
        }
    }
    
    private func isMyMessage(_ message: ChatMessage) -> Bool {
        return message.sender == UserManager.shared.currentUser?.nickname
    }
    
    private func isScrolledToBottom() -> Bool {
        guard !collectionView.bounds.isEmpty else { return true }
        
        let visibleHeight = collectionView.bounds.height
        let contentHeight = collectionView.contentSize.height
        let contentOffsetY = collectionView.contentOffset.y
        
        // 스크롤 위치가 마지막 셀을 보여주는 위치에 있는지 확인 (여유 공간 20포인트 추가)
        return contentOffsetY >= contentHeight - visibleHeight - 20
    }
}

private extension UICollectionView {
    func scrollToLastItem(at scorllPosition: UICollectionView.ScrollPosition, animated: Bool){
        guard numberOfItems(inSection: numberOfSections - 1) > 0 else {return}
        
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfItems(inSection: lastSectionIndex) - 1
        let lastRowIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        
        scrollToItem(at: lastRowIndexPath, at: scorllPosition, animated: animated)
    }
}


struct NewMessageBar: View {
    @ObservedObject var viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel){
        self.viewModel = viewModel
    }

    var body : some View {
        Button(action: {
                viewModel.showNewMessageBanner = false
        }) {
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                Text("새 메시지가 있습니다")
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
}
