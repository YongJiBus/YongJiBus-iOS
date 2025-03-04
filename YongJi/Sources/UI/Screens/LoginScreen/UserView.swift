//
//  UserView.swift
//  YongJiBus
//
//  Created by 김도경 on 2/23/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingLogoutAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("내 정보")
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
            
            // Profile Image
            Circle()
                .fill(Color("RowColor"))
                .frame(width: 120, height: 120)
                .overlay(
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .padding(30)
                )
                .padding(.bottom, 20)
            
            // User Information
            VStack(spacing: 16) {
                userInfoRow(title: "이메일", value: viewModel.userEmail)
                userInfoRow(title: "이름", value: viewModel.userName)
                userInfoRow(title: "닉네임", value: viewModel.userNickname)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Logout Button
            Button {
                showingLogoutAlert = true
            } label: {
                Text("로그아웃")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(18)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .alert("로그아웃", isPresented: $showingLogoutAlert) {
            Button("취소", role: .cancel) {}
            Button("로그아웃", role: .destructive) {
                viewModel.logout()
                dismiss()
            }
        } message: {
            Text("정말 로그아웃 하시겠습니까?")
        }
    }
    
    private func userInfoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Text(value.isEmpty ? "정보 없음" : value)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("RowColor"))
                .cornerRadius(10)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
