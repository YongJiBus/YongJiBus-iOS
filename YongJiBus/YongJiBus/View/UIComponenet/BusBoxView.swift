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
            viewModel.load(busNumber)
        }, label: {
            HStack{
                ZStack{
                    Circle()
                        .fill(.white)
                        .frame(width: 50,height: 55)
                    Image(systemName: "bus")
                        .resizable()
                        .frame(width: 30,height: 30)
                        .foregroundStyle(Color("BusColor"))
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
            .frame(width: 155,height: 85)
            .background(Color("BusColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .task {
                viewModel.load(busNumber)
            }
        })
        .buttonStyle(.plain)
        .onAppear{
            viewModel.load(busNumber)
        }
    }
}

struct BusBoxView_Previews: PreviewProvider {
    static var previews: some View {
        BusBoxView(.three)
    }
}
