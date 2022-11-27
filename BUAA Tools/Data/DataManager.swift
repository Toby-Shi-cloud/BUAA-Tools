//
//  DataManager.swift
//  BUAA Tools
//
//  Created by mac on 2022/11/27.
//

import Foundation

protocol DataManager: ObservableObject {
    var recentDelta: [SimpleDate:Double] { get set }
    var recentTotal: [SimpleDate:Double] { get set }
    var hasError: Bool { get set }
    init()
    func manageData(from date_st: Date, to date_ed: Date, username: String) async throws
}
