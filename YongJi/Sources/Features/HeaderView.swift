import SwiftUI

struct HeaderView: View {
    
    @Binding var topBarType : TopBarType
    
    @State private var isModalPresented = false
    
    @State var imageName = "info.circle"
    
    @EnvironmentObject var appViewModel: AppViewModel
    
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
                .fullScreenCover(isPresented: $isModalPresented) {
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
                        if appViewModel.isLogin {
                            UserView()
                        }  else {
                            LoginView()
                        }
                    }
                }
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
