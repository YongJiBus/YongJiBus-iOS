import SwiftUI

struct HeaderView: View {
    
    @Binding var topBarType : TopBarType
    
    @State private var isModalPresented = false
    
    @State var imageName = "info.circle"
    
    var body: some View {
        HStack{
            Text(topBarType.text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.black)
                .navigationDestination(isPresented: $isModalPresented, destination: {
                    switch topBarType {
                    case .MyongJi:
                        ShuttleInfoView()
                            .presentationCornerRadius(15)
                    case .Giheung:
                        ShuttleInfoView()
                            .presentationCornerRadius(15)
                    case .Taxi:
                        ShuttleInfoView()
                            .presentationCornerRadius(15)
                    case .Setting:
                        SignUpView()
                    }
                })
//                .sheet(isPresented: self.$isModalPresented){
//                    NavigationView{
//                        switch topBarType {
//                        case .MyongJi:
//                            ShuttleInfoView()
//                                .presentationCornerRadius(15)
//                        case .Giheung:
//                            ShuttleInfoView()
//                                .presentationCornerRadius(15)
//                        case .Taxi:
//                            ShuttleInfoView()
//                                .presentationCornerRadius(15)
//                        case .Setting:
//                            SignUpView()
//                        }
//
//                    }
//                    .navigationTitle("셔틀상세정보")
//                }
                .onTapGesture {
                    isModalPresented.toggle()
                }
        }//Hstack
        .background(.white)
        .padding(.horizontal)
        .onChange(of: topBarType) {
            switch topBarType {
            case .MyongJi:
                self.imageName = "info.circle"
            case .Giheung:
                self.imageName = "info.circle"
            case .Taxi:
                self.imageName = "info.circle"
            case .Setting:
                self.imageName = "person.circle"
            }
        }
    }
}
