//
//  TrafficView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//
//  Traffic - 校园网流量
//

import SwiftUI

struct TrafficView: View {
    @ObservedObject var content : Traffic
    let user : User

    init(content: Traffic, user: User = User.defaultUser) {
        self.content = content.asyncQuery(user: user)
        self.user = user
    }
    
    var body: some View {
        switch content.trafficState {
        case .successed, .disable:
            VStack {
                if content.freeTraffic != nil {
                    GroupBox(label: HStack {
                        Text("免费流量：")
                        VStack {
                            Text("总计：\(content.freeTraffic!.tot.toString()) G")
                            Text("剩余：\(content.freeTraffic!.res.toString()) G")
                        }
                    }) {
                        ProgressView(value: usePercentage(value: content.freeTraffic) ?? 0)
                            .progressViewStyle(CapsuleProgressViewStyle(textColor: .primary, progressColor: .green))
                            .frame(height: 20, alignment: .center)
                    }
                } else {
                    Text("免费流量：加载失败(^_−)−☆")
                }
                
                if content.giftTraffic != nil {
                    if content.giftTraffic!.tot != 0 {
                        GroupBox(label: HStack {
                            Text("赠送流量：")
                            VStack {
                                Text("总计：\(content.giftTraffic!.tot.toString()) G")
                                Text("剩余：\(content.giftTraffic!.res.toString()) G")
                            }
                        }) {
                            ProgressView(value: usePercentage(value: content.giftTraffic) ?? 0)
                                .progressViewStyle(CapsuleProgressViewStyle(textColor: .primary, progressColor: .green))
                                .frame(height: 20, alignment: .center)
                        }
                    }
                } else {
                    Text("赠送流量：加载失败(^_−)−☆")
                }
                
                if content.paidTraffic != nil {
                    GroupBox(label: HStack {
                        Text("计费流量：")
                        Text("剩余：\(content.paidTraffic!.toString()) G")
                    }) {
                        ProgressView(value: content.paidTraffic != nil ? min(usePercentage(value: (100, content.paidTraffic!))!, 1.0) : 0)
                            .progressViewStyle(CapsuleProgressViewStyle(showPercentage: false, additionalLabel: "\(content.paidTraffic!.toString()) G", textColor: .primary, progressColor: .green))
                            .frame(height: 20, alignment: .center)
                    }
                } else {
                    Text("计费流量：加载失败(^_−)−☆")
                }
            }
        case .excuting:
            Text("流量查询：加载中！(*^o^*)")
        case .failed:
            Text("流量查询：加载失败(^_−)−☆")
        case .error:
            Text("流量查询：出现错误……")
        }
    }
}

struct TrafficView_Previews: PreviewProvider {
    static var content : Traffic = Traffic(
        freeTraffic: (tot: 30, res: Double.random(in: 0.0...30.0)),
        giftTraffic: (tot: 0, res: 0),
        paidTraffic: Double.random(in: 50.0...200.0))
    static var previews: some View {
        TrafficView(content: content).environment(\.colorScheme, .light)
    }
}
