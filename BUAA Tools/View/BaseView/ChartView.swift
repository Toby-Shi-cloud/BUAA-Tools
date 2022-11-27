//
//  ChartView.swift
//  BUAA Tools
//
//  Created by mac on 2022/11/27.
//

import SwiftUI
import Charts

struct ChartView<Content>: View where Content: DataManager {
    @Environment(\.scenePhase) private var scenePhase
    let currentDay = SimpleDate(from: Date())
    @StateObject var content = Content()
    @State var days: Int = 7

    func load() {
        Task {
            do {
                try await content.manageData(from: (currentDay + -30).toDate(), to: currentDay.toDate(), username: User.defaultUser.username)
            } catch {
                DispatchQueue.main.async {
                    content.hasError = true
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Picker("days", selection: $days.animation(.easeInOut)) {
                Text("7 days").tag(7)
                Text("10 days").tag(10)
                Text("15 days").tag(15)
                Text("20 days").tag(20)
            }.pickerStyle(.segmented)
            Chart {
                ForEach(indexToModel(value: Array(0..<days).reversed())) { model in
                    if content.recentDelta[currentDay + -model.index] != nil {
                        BarMark(
                            x: .value("Day", "\((currentDay + -model.index).day)"),
                            y: .value("Value", content.recentDelta[currentDay + -model.index]!)
                        )
                        .foregroundStyle(.green)
                        .symbol(by: .value("Type", "使用"))
                    }
                    if content.recentTotal[currentDay + -model.index] != nil {
                        LineMark(
                            x: .value("Day", "\((currentDay + -model.index).day)"),
                            y: .value("Value", content.recentTotal[currentDay + -model.index]!)
                        ).symbol(by: .value("Type", "余量"))
                    }
                }
            }
        }
        .onChange(of: scenePhase) { value in
            if value == .active {
                self.load()
            }
        }
        .alert(isPresented: $content.hasError) {
            Alert(title: Text("数据错误"), message: Text("数据加载出现错误！请稍后再试！"))
        }
    }
}

class DemoData: DataManager {
    var recentDelta: [SimpleDate : Double] = [:]
    var recentTotal: [SimpleDate : Double] = [:]
    var hasError: Bool = false
    
    required init() {
        let today = SimpleDate(from: Date())
        for i in 0...500 {
            recentDelta[today + -i] = Double.random(in: -100.0...200.0)
            recentTotal[today + -i] = Double.random(in: 0.0...1000.0)
        }
    }
    
    func manageData(from date_st: Date, to date_ed: Date, username: String) async throws {}
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView<DemoData>().padding()
    }
}
