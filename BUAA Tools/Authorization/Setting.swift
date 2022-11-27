//
//  Setting.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import Foundation

struct IndexModel: Identifiable, Hashable {
    let id = UUID()
    let index: Int
}

class UserSetting: ObservableObject {
    static let viewShowingTitles = ["校园网流量：", "TD 次数：", "校园卡余额：", "健康打卡状态："]
    static let viewSettingTitles = ["校园网流量", "TD 查询", "校园卡余额", "健康打卡状态"]
    static let viewCount = UserSetting.viewShowingTitles.count
    @Published var viewIndexModel: [IndexModel] = []
    @Published var tdShowWebsite: Bool = false
    @Published var hideBalance: Bool = false
    @Published var nrecordTrafficData: Bool = false
    @Published var nrecordBalanceData: Bool = false
    
    static let defaultSetting = UserSetting()
    
    private init() {
        loadSetting()
    }
    
    func saveSetting() {
        UserDefaults.standard.set(modelToIndex(value: viewIndexModel), forKey: UserProfile.viewIndex.rawValue)
        UserDefaults.standard.set(tdShowWebsite, forKey: UserProfile.tdShowWebsite.rawValue)
        UserDefaults.standard.set(hideBalance, forKey: UserProfile.hideBalance.rawValue)
        UserDefaults.standard.set(nrecordTrafficData, forKey: UserProfile.nrecordTrafficData.rawValue)
        UserDefaults.standard.set(nrecordBalanceData, forKey: UserProfile.nrecordBalanceData.rawValue)
    }
    
    private func checkIndex(viewIndex: [Int]?) -> Bool {
        guard let viewIndex = viewIndex else { return false }
        if (viewIndex.count != UserSetting.viewCount) { return false }
        var appear: [Bool] = Array(repeating: false, count: UserSetting.viewCount)
        for index in viewIndex {
            guard 0..<UserSetting.viewCount ~= index,
                  !appear[index] else { return false }
            appear[index] = true
        }
        return true
    }
    
    func loadSetting() {
        tdShowWebsite = UserDefaults.standard.bool(forKey: UserProfile.tdShowWebsite.rawValue)
        hideBalance = UserDefaults.standard.bool(forKey: UserProfile.hideBalance.rawValue)
        nrecordTrafficData = UserDefaults.standard.bool(forKey: UserProfile.nrecordTrafficData.rawValue)
        nrecordBalanceData = UserDefaults.standard.bool(forKey: UserProfile.nrecordBalanceData.rawValue)
        let viewIndex = UserDefaults.standard.array(forKey: UserProfile.viewIndex.rawValue) as? [Int]
        if (!checkIndex(viewIndex: viewIndex)) {
            self.viewIndexModel = indexToModel(value: Array(0..<UserSetting.viewCount))
        } else {
            self.viewIndexModel = indexToModel(value: viewIndex!)
        }
    }
}
