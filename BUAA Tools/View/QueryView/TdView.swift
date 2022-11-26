//
//  TdView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//
//  TD - TD查询
//

import SwiftUI

struct TdSingleView: View {
    let content: (term: String, value: Int)
    var body: some View {
        GroupBox(label: HStack {
            Text(content.term + ":")
            Text("\(content.value)")
        }) {
            ProgressView(value: min(Double(content.value) / 48.0, 1.0))
                .progressViewStyle(CapsuleProgressViewStyle(showPercentage: false, additionalLabel: "\(content.value)", textColor: .primary, progressColor: .green))
                .frame(height: 20, alignment: .center)
        }
    }
}

struct TdViewModel: Identifiable, Hashable {
    let id = UUID()
    let term: String
    let value: Int
}

struct TdFullView: View {
    let content : [TdViewModel]
    var body: some View {
        ZStack {
            BackgoundView().opacity(0.5)
            VStack(spacing: 20) {
                Text("TD 详细信息").font(.title).bold(true)
                if content.count != 0 {
                    ForEach(content) { td in
                        TdSingleView(content: (term: td.term, value: td.value))
                    }
                } else {
                    Text("未能查询到信息:-(")
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .frame(maxWidth: 360)
        }
    }
}

struct TdView: View {
    @ObservedObject var content : TdLine
    let user : User
    
    init(content: TdLine, user: User = User.defaultUser) {
        self.content = content.asyncQuery(user: user)
        self.user = user
    }
    
    var body: some View {
        switch content.tdState {
        case .successed, .disable:
            if content.tdValue.count != 0 {
                TdSingleView(content: content.tdValue[0])
            } else {
                Text("未能查询到信息:-(")
            }
        case .excuting:
            Text("加载中^o^")
        case .failed:
            Text("加载失败:-(")
        case .error:
            Text("出现错误……")
        }
    }
}

struct TdView_Previews: PreviewProvider {
    static let content = TdLine(tdValue: [
        (term: "2022-2023 秋季学期", value: Int.random(in: 0...48)),
        (term: "2021-2022 夏季学期", value: Int.random(in: 40...60))
    ])
    static var previews: some View {
        TdView(content: TdView_Previews.content, user: User.defaultUser)
            .environment(\.colorScheme, .light)
    }
}

struct TdFullView_Previews: PreviewProvider {
    static var previews: some View {
        TdFullView(content: tdsToTdModels(value: TdView_Previews.content.tdValue))
    }
}
