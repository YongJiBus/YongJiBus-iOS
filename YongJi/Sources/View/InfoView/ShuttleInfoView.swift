//
//  ShuttleInfoView.swift
//  YongJiBus
//
//  Created by 김도경 on 3/7/24.
//

import SwiftUI
import MapKit


//MARK: WORKING FOR UPDATE

struct ShuttleInfoView: View {
    //@Binding var modalState : Bool
    
    @ObservedObject var viewModel = InfoViewModel()
    
    @State private var route : MKRoute?

    var body: some View {
        //
        OptionRow{
            Text("곧 신기능으로 돌아올게요~!")
        }
        
//        VStack(alignment:.leading){
//            Map{
//                ForEach(viewModel.mapPoints){ mapPoint in
//                    Annotation(mapPoint.name, coordinate: mapPoint.points) {
//                        Circle().fill(Color("RowNumColor"))
//                    }
//                }
//            }
//            .onAppear(perform: {
//                getDirections()
//            })
//            .mapStyle(.standard)
//            .mapControls {
//                MapUserLocationButton()
//            }
//            VStack{
//                HStack{
//                    Text("운행구간")
//                        .font(.largeTitle)
//                        .bold()
//                    Spacer()
//                }
//                OptionRow{
//                    Circle()
//                        .frame(width: 10)
//                        .foregroundStyle(.white)
//                    VStack(alignment:.leading){
//                        Text("버스관리사무소")
//                        Text("상공회의소")
//                        Text("진입로(럭스나인 앞)")
//                        Text("경전철 명지대역")
//                        Text("명지대역 사거리 정류장")
//                        Text("진입로(역북동 주민센터)")
//                        Text("이마트")
//                        Text("명진당")
//                        Text("제3공학관")
//                        Text("함박관")
//                        Text("창조관")
//                        Text("버스관리사무소")
//                    }
//                    Spacer()
//                }
//            }
//            .padding()
//        }
//            .frame(width: .infinity,height: .infinity)
    }
    
    
    func getDirections(){
    }
}

#Preview {
    ShuttleInfoView()
}
