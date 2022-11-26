import Foundation
import SwiftyJSON

class Balance: ObservableObject {
    @Published var balance : Double? = nil
    @Published var unclaimedAmount : Double? = nil
    @Published var balanceState : ActionState = .failed
    
    init(isPreview: Bool = false) {
        if isPreview {
            balance = Double.random(in: 0.0...10000.0)
            unclaimedAmount = Double.random(in: 0.0...500.0)
            balanceState = .disable
        }
    }
    
    func asyncQuery(user: User) -> Balance {
        Task { await query(user: user) }
        return self
    }
    
    private func payLogin(user: User) async -> Bool {
        if user.loginState != .successed {
            while user.loginState == .excuting {}
            guard user.loginState == .successed else { return false }
        }
        guard let (_, response) = try? await URLSession.shared.data(from: .balanceLoginURL) else { return false }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else { return false }
        return true
    }
    
    func query(user: User) async -> Bool {
        if balanceState == .disable {
            balance = Double.random(in: 0.0...10000.0)
            unclaimedAmount = Double.random(in: 0.0...500.0)
            return true
        }
        if balanceState == .excuting { return false } // 防止重复调用
        defer {
            DispatchQueue.main.async {
                if self.balanceState == .excuting {
                    self.balanceState = .failed
                }
            }
        }
        DispatchQueue.main.async { self.balanceState = .excuting }
        guard await payLogin(user: user) else { return false }
        let url = URL.getBalanceURL(username: user.username)
        guard let (data, response) = try? await URLSession.shared.data(from: url) else { return false }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else { return false }
        guard let jsonData = try? JSON(data: data),
              jsonData["success"] == true else { return false }
        DispatchQueue.main.sync {
            balance = Double(jsonData["data"]["balance"].string ?? "")
            unclaimedAmount = Double(jsonData["data"]["unclaimedAmount"].string ?? "")
        }
        guard balance != nil else { return false }
        DispatchQueue.main.async { self.balanceState = .successed }
        return true
    }
}
