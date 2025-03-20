import SwiftUI

struct HeaderView: View {
    
    @Binding var topBarType : TopBarType
    
    @State private var isSheetPresented = false
    @State private var isFullScreenPresented = false
    
    @State var imageName = "map"
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        HStack{
            Text(topBarType.text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            if topBarType != .Taxi {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                    .sheet(isPresented: $isSheetPresented) {
                        if topBarType == .MyongJi {
                            ShuttleInfoView()
                                .environmentObject(appViewModel)
                        } else if topBarType == .Giheung {
                            GiheungInfoView()
                        }
                    }
                    .fullScreenCover(isPresented: $isFullScreenPresented) {
                        if topBarType == .Setting {
                            if appViewModel.isLogin {
                                UserView()
                            } else {
                                LoginView()
                            }
                        }
                    }
                    .onTapGesture {
                        if topBarType == .Setting {
                            isFullScreenPresented.toggle()
                        } else {
                            isSheetPresented.toggle()
                        }
                    }
            }
        }//Hstack
        .background(.white)
        .padding(.horizontal)
        .onChange(of: topBarType) {
            switch topBarType {
            case .MyongJi:
                self.imageName = "map"
            case .Giheung:
                self.imageName = "map"
            case .Taxi:
                self.imageName = "info.circle"
            case .Setting:
                self.imageName = "person.circle"
            }
        }
    }
}
