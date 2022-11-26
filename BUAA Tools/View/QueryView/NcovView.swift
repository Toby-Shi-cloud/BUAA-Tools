//
//  NcovView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//
//  NCOV - 每日健康打卡
//

import SwiftUI

struct NcovView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var content : Ncov
    let user : User
    
    init(content: Ncov, user: User = User.defaultUser) {
        self.content = content.asyncQuery(user: user)
        self.user = user
    }
    
    var body: some View {
        VStack{
            switch content.ncovState {
            case .successed, .disable:
                if content.hasFlag == true {
                    Text("今日已打卡！").foregroundColor(.green)
                } else if content.ontime == true {
                    Text("已到打卡时间！请迅速打卡！").foregroundColor(.red)
                } else {
                    Text("未到打卡时间。").foregroundColor(.gray)
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

struct NcovView_Previews: PreviewProvider {
    static var previews: some View {
        NcovView(content: Ncov(isPreview: true))
    }
}
