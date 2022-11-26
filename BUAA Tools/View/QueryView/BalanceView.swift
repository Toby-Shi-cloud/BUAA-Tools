//
//  BalanceView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//
//  Balance - 航财通
//

import SwiftUI

struct BalanceView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var setting = UserSetting.defaultSetting
    @ObservedObject var content: Balance
    let user: User
    
    init(content: Balance, user: User = User.defaultUser) {
        self.content = content.asyncQuery(user: user)
        self.user = user
    }
    
    var body: some View {
        VStack{
            HStack {
                Text("余额（元）")
            }.padding(2)
            switch content.balanceState {
            case .successed, .disable:
                VStack {
                    Text(setting.hideBalance ? "**.**" : String(format: "%.2f", content.balance!))
                        .font(.title2)
                        .bold(true)
                        .padding(1)
                    content.unclaimedAmount != nil && content.unclaimedAmount! > 0
                    ? AnyView(Text("（待领取：\(setting.hideBalance ? "**.**" : String(format: "%.2f", content.unclaimedAmount!))）"))
                    : AnyView(EmptyView())
                }
            case .excuting:
                Text("加载中……")
            case .failed:
                Text("加载失败……")
            case .error:
                Text("出现错误……")
            }
        }
        .padding()
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView(content: Balance(isPreview: true), user: User.defaultUser)
    }
}
