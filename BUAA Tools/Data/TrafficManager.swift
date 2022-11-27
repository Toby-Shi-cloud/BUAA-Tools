//
//  TrafficManager.swift
//  BUAA Tools
//
//  Created by mac on 2022/11/27.
//

import Foundation

class TrafficManager: DataManager {
    @Published var recentDelta: [SimpleDate:Double] = [:]
    @Published var recentTotal: [SimpleDate:Double] = [:]
    @Published var hasError = false
    
    required init() {
        Task {
            let currentDay = SimpleDate(from: Date())
            do {
                try await self.manageData(from: (currentDay + -30).toDate(), to: currentDay.toDate())
            } catch {
                DispatchQueue.main.async {
                    self.hasError = true
                }
            }
        }
    }
    
    func manageData(from date_st: Date, to date_ed: Date, username: String = User.defaultUser.username) async throws {
        var recentDelta: [SimpleDate:Double] = [:]
        var recentTotal: [SimpleDate:Double] = [:]
        var traffics = try UserData.dataModel.fetchTrafficBetween(from: date_st - (30*24*3600), to: date_ed + (24*3600), username: username)
        try traffics.sort {
            guard let d0 = $0.date else { throw AppException.DataError }
            guard let d1 = $1.date else { throw AppException.DataError }
            return d0 < d1
        }
        var last_total: Double? = nil
        var last_date: SimpleDate? = nil
        for traffic in traffics {
            if last_total == nil {
                last_total = traffic.free_res + traffic.gift_res + traffic.paid
                guard let date = traffic.date else { throw AppException.DataError }
                last_date = SimpleDate(from: date)
                recentTotal[last_date!] = last_total!
            } else {
                let cur_total = traffic.free_res + traffic.gift_res + traffic.paid
                guard let date = traffic.date else { throw AppException.DataError }
                let cur_date = SimpleDate(from: date)
                let diff = cur_date - last_date!
                if diff < 1 { continue }
                let every_delta = (last_total! - cur_total) / Double(diff)
                for i in 1...diff {
                    recentDelta[last_date!+i] = every_delta
                    recentTotal[last_date!+i] = last_total! - Double(i) * every_delta
                }
                last_date = cur_date
                last_total = cur_total
            }
        }
        DispatchQueue.main.async { [recentDelta, recentTotal] in
            self.recentDelta = recentDelta
            self.recentTotal = recentTotal
        }
    }
}
