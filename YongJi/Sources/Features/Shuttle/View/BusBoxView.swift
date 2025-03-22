//
//  BusBoxView.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/07/01.
//

import SwiftUI

struct BusBoxView: View {
    
    @ObservedObject var viewModel = BusBoxViewViewModel()
    @State private var isLoading = false
    
    private var title: String
    private let busNumber: BusNumber
    
    init(_ busNumber: BusNumber) {
        self.busNumber = busNumber
        self.title = busNumber.title
    }

    var body: some View {
        Button(action: {
            isLoading = true
            viewModel.load(busNumber) {
                isLoading = false
            }
        }, label: {
            HStack {
                BusIconView(isLoading: isLoading)
                    .padding(.leading, 10)
                BusInfoView(title: title, text: viewModel.text)
                    .padding(.trailing, 10)
            }
            .frame(height: 85)
            .background(Color("BusColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        })
        .buttonStyle(.plain)
        .onAppear {
            isLoading = true
            viewModel.load(busNumber) {
                isLoading = false
            }
        }
    }
}

// LoadingIndicatorView.swift
struct BusIconView: View {
    var isLoading: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 50, height: 55)
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5, anchor: .center)
                    .tint(Color("BusColor"))
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "bus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color("BusColor"))
            }
        }
    }
}

// BusInfoView.swift
struct BusInfoView: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            ZStack {
                Text(text)
                    .font(.body)
                    .foregroundStyle(.black)
            }
        }
    }
}



struct BusBoxView_Previews: PreviewProvider {
    static var previews: some View {
        BusBoxView(.oneA)
    }
}
