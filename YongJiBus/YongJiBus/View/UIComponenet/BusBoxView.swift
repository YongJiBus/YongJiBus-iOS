//
//  BusBoxView.swift
//  YONGJIBUS
//
//  Created by 김도경 on 2023/07/01.
//

import SwiftUI

struct BusBoxView: View {
    
    @ObservedObject var viewModel = BusBoxViewViewModel()
    
    private var title : String
    private let busNumber : BusNumber
    
    init(_ busNumber : BusNumber){
        self.busNumber = busNumber
        self.title = busNumber.title
    }

    var body: some View {
        Button(action: {
            viewModel.loading()
            viewModel.load(busNumber){
                viewModel.stopLoading()
            }
        }, label: {
            HStack{
                ZStack{
                    Circle()
                        .fill(.white)
                        .frame(width: 50,height: 55)
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.5, anchor: .center)
                            .tint(Color("BusColor"))
                            .frame(width: 50,height: 50)
                    } else {
                        Image(systemName: "bus")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundStyle(Color("BusColor"))
                    }
                }
                VStack(alignment: .leading){
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    ZStack{
                        Text(viewModel.text)
                            .font(.body)
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(width: 165,height: 85)
            .background(Color("BusColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        })
        .buttonStyle(.plain)
        .onAppear{
            viewModel.loading()
            viewModel.load(busNumber){
                viewModel.stopLoading()
            }
        }
    }
}


struct BusBoxView_Previews: PreviewProvider {
    static var previews: some View {
        BusBoxView(.oneA)
    }
}
