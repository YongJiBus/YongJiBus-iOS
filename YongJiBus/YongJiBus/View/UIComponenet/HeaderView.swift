import SwiftUI

struct HeaderView: View {
    
    @Binding var title : String
    
    @State private var isModalPresented = false
    
    var imageName = "info.circle"
    
    var body: some View {
        HStack{
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.black)
                .sheet(isPresented: self.$isModalPresented){
                    NavigationView{
                        ShuttleInfoView()
                            .presentationCornerRadius(15)
                    }
                    .navigationTitle("셔틀상세정보")
                }
                .onTapGesture {
                    isModalPresented.toggle()
                }
        }//Hstack
        .background(.white)
        .padding(.horizontal)
    }
}
