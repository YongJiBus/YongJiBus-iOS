import SwiftUI

struct HeaderView: View {
    
    @Binding var topBarType : TopBarType
    
    @State private var isModalPresented = false
    
    @EnvironmentObject var appViewModel : AppViewModel
    
    @State var imageName = "map"
    
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
                .sheet(isPresented: self.$isModalPresented){
                    switch topBarType {
                    case .MyongJi:
                        ShuttleInfoView()
                            .presentationCornerRadius(15)
                            .environmentObject(appViewModel)
                    case .Giheung:
                        GiheungInfoView()

                    case .Setting:
                        Text("로그인 기능으로 돌아올게요")
                    }
                }
                .onTapGesture {
                    isModalPresented.toggle()
                }
                .onChange(of: topBarType) {
                    switch topBarType {
                    case .MyongJi:
                        self.imageName = "map"
                    case .Giheung:
                        self.imageName = "map"
                    case .Setting:
                        self.imageName = "info.circle"
                    }
                }
        }//Hstack
        .background(.white)
        .padding(.horizontal)
    }
}
