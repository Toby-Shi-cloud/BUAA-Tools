//
//  SettingView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showingSetting: Bool
    @State var viewIndexModel = UserSetting.defaultSetting.viewIndexModel
    @State var tdShowWebsite = UserSetting.defaultSetting.tdShowWebsite
    @State var hideBalance = UserSetting.defaultSetting.hideBalance
    @State var recordTrafficData = !UserSetting.defaultSetting.nrecordTrafficData
    @State var recordBalanceData = !UserSetting.defaultSetting.nrecordBalanceData
    @State var modelID: IndexModel.ID? = nil
    @State var logout: Bool = false
    let titles = UserSetting.viewSettingTitles
    
    var body: some View {
        List {
            Section("视图顺序") {
                ForEach(viewIndexModel) { model in
                    HStack {
                        Text(titles[model.index])
                        Spacer()
                        Image(systemName: "list.bullet")
                    }
                }.onMove { (from, to) in
                    viewIndexModel.move(fromOffsets: from, toOffset: to)
                }
            }
            Section("视图设置") {
                Toggle(isOn: $tdShowWebsite) {
                    Text("TD详情页面显示网页")
                }
                Toggle(isOn: $hideBalance) {
                    Text("隐藏校园卡余额")
                }
            }
            Section("数据储存") {
                Toggle(isOn: $recordTrafficData) {
                    Text("储存流量数据")
                }
                Toggle(isOn: $recordBalanceData) {
                    Text("存储校园卡余额")
                }
            }
        }.safeAreaInset(edge: .top, alignment: .center, spacing: 0) { Rectangle().frame(height: 60).foregroundColor(Color.clear) }
        .cornerRadius(20)
        .overlay(alignment: .topTrailing) {
            Button {
                UserSetting.defaultSetting.viewIndexModel = viewIndexModel
                UserSetting.defaultSetting.tdShowWebsite = tdShowWebsite
                UserSetting.defaultSetting.hideBalance = hideBalance
                UserSetting.defaultSetting.nrecordTrafficData = !recordTrafficData
                UserSetting.defaultSetting.nrecordBalanceData = !recordBalanceData
                UserSetting.defaultSetting.saveSetting()
                showingSetting.toggle()
            } label: {
                Text("完成")
                    .frame(width: 60, height: 40)
            }.padding(20)
        }.overlay(alignment: .topLeading) {
            Button {
                showingSetting.toggle()
            } label: {
                Text("取消")
                    .frame(width: 60, height: 40)
            }.padding(20)
        }
        .overlay(alignment: .bottom) {
            Button {
                logout.toggle()
            } label: {
                Text("退出登录")
                    .font(.callout)
                    .bold(true)
                    .foregroundColor(.red)
                    .frame(width: 200, height: 70)
            }.padding()
        }
        .alert(isPresented: $logout) {
            Alert(
                title: Text("退出登录"),
                message: Text("您确定要退出登录吗？"),
                primaryButton: .default(Text("取消")),
                secondaryButton: .destructive(Text("确定")) {
                    User.defaultUser.logout()
                }
            )
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showingSetting: .constant(true)).environment(\.colorScheme, .light)
    }
}

