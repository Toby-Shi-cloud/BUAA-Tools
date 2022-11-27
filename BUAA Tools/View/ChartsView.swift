//
//  ChartsView.swift
//  BUAA Tools
//
//  Created by mac on 2022/11/27.
//

import SwiftUI

enum ChartSelector {
    case traffic, balance
}

struct ChartsView: View {
    @State var content: ChartSelector = .traffic
    
    var body: some View {
        VStack {
            Picker("数据", selection: $content) {
                Text("流量用量").tag(ChartSelector.traffic)
                Text("校园卡余额").tag(ChartSelector.balance)
            }.pickerStyle(.segmented).padding()
            switch content {
            case .traffic:
                if UserSetting.defaultSetting.nrecordTrafficData {
                    Text("No Data!")
                        .font(.largeTitle)
                        .bold(true)
                        .padding()
                } else {
                    ChartView<TrafficManager>().padding()
                }
            case .balance:
                if UserSetting.defaultSetting.nrecordBalanceData {
                    Text("No Data!")
                        .font(.largeTitle)
                        .bold(true)
                        .padding()
                } else {
                    ChartView<BalanceManager>().padding()
                }
            }
        }
    }
}
