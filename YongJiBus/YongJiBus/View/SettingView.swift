//
//  SettingView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/08/17.
//

import SwiftUI



struct SettingView: View {
    
    @State var isWeekend : Bool
    
    init() {
        self.isWeekend = DataManager.getData(key: .weekend) as! Bool
    }
    
    
    var body: some View {
        VStack(alignment:.leading){
            VStack{
                OptionRow{
                    Text("시간표 설정")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .foregroundStyle(Color("RowNumColor"))
                        .opacity(0.7)
                    Spacer()
                    Section{
                        Picker("Weekend Option", selection: $isWeekend){
                            Text("평일")
                                .tag(false)
                            Text("주말")
                                .tag(true)
                        }
                        .onChange(of: isWeekend, perform: { value in
                            DataManager.setData(data: value, key: .weekend)
                        })
                        .pickerStyle(.segmented)
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                }
                OptionRow{
                    Text("문의")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .foregroundStyle(Color("RowNumColor"))
                        .opacity(0.7)
                    Spacer()
                    Text("prunsoli11@gmail.com")
                }
                
                Spacer()
            }
            .padding()
        }//TopVstack
        .background(.white)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
