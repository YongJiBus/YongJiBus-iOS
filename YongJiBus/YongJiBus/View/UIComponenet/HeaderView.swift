import SwiftUI

struct HeaderView: View {
    
    @Binding var title : String
    var imageName = "gearshape"
    
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
                .onTapGesture {
                    title = "설정"
                }
        }//Hstack
        .background(.white)
        .padding(.horizontal)
    }
}
