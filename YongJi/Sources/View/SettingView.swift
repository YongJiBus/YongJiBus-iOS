//
//  SettingView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/08/17.
//

import SwiftUI



struct SettingView: View {
    
    @State var isWeekend : Bool
    @State var isHolidayAuto : Bool
    
    init() {
        self.isWeekend = DataManager.getData(key: .weekend) as! Bool
        self.isHolidayAuto = false
    }
    
    
    var body: some View {
        VStack(alignment:.leading){
            VStack{
                timeSettingOption
                automateHolidayOption
                developerContact
                
                Spacer()
            }
            .padding()
        }//TopVstack
        .background(.white)
    }
    
    var automateHolidayOption : some View {
        OptionRow{
            Text("공휴일 자동 설정")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(Color("RowNumColor"))
                .opacity(0.7)
            Spacer()
            Toggle(isOn: $isHolidayAuto, label: {})
                .toggleStyle(.switch)
        }
    }
    
    var timeSettingOption : some View {
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
                .onChange(of: isWeekend, { oldValue, newValue in
                    DataManager.setData(data: newValue, key: .weekend)
                })
                .pickerStyle(.segmented)
            }
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
        }
    }
    
    var developerContact : some View {
        OptionRow{
            Text("문의")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(Color("RowNumColor"))
                .opacity(0.7)
            Spacer()
            Text("prunsoli11@gmail.com")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
