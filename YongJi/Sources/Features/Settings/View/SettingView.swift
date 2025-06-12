//
//  SettingView.swift
//  YongJiBus
//
//  Created by 김도경 on 2023/08/17.
//

import Alamofire
import SwiftUI

struct SettingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                timeSettingOption
                automateHolidayOption
                developerContact
                Spacer()
            }
            .padding()
        }
        .background(.white)
        .onAppear {
            AnalyticsManager.shared.logScreenView(
                screenName: "SettingView",
                screenClass: "SettingView"
            )
        }
    }
    
    var automateHolidayOption: some View {
        OptionRow {
            Text("공휴일 자동 설정")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(Color("RowNumColor"))
                .opacity(0.7)
            Spacer()
            Toggle(isOn: $appViewModel.isHolidayAuto, label: {})
                .toggleStyle(.switch)
                .onChange(of: appViewModel.isHolidayAuto) {
                    if appViewModel.isHolidayAuto {
                        appViewModel.fetchDayType()
                    }
                }
        }
    }
    
    var timeSettingOption: some View {
        OptionRow {
            Text("시간표 설정")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(Color("RowNumColor"))
                .opacity(0.7)
            Spacer()
            Section {
                Picker("Weekend Option", selection: $appViewModel.isHoliday) {
                    Text("평일")
                        .tag(false)
                    Text("주말")
                        .tag(true)
                }
                .pickerStyle(.segmented)
                .disabled(appViewModel.isHolidayAuto)
            }
            .frame(width: 100)
        }
    }
    
    var developerContact: some View {
        OptionRow {
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
        SettingView().environmentObject(AppViewModel())
    }
}
