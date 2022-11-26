import Foundation
import SwiftyJSON

class Ncov: ObservableObject {
    @Published var hasFlag : Bool? = nil
    @Published var ontime : Bool? = nil
    @Published var ncovState : ActionState = .failed
    
    init(isPreview: Bool = false) {
        if isPreview {
            hasFlag = Bool.random()
            ontime = Bool.random()
            ncovState = .disable
        }
    }
    
    func asyncQuery(user: User) -> Ncov {
        Task { await query(user: user) }
        return self
    }
    
    func query(user: User) async -> Bool {
        if ncovState == .disable {
            hasFlag = Bool.random()
            ontime = Bool.random()
            return true
        }
        if ncovState == .excuting { return false } // 防止重复调用
        defer {
            DispatchQueue.main.async {
                if self.ncovState == .excuting {
                    self.ncovState = .failed
                }
            }
        }
        DispatchQueue.main.async { self.ncovState = .excuting }
        if user.loginState != .successed {
            while user.loginState == .excuting {}
            guard user.loginState == .successed else { return false }
        }
        guard let (data, response) = try? await URLSession.shared.data(from: .ncovURL) else { return false }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else { return false }
        guard let jsonData = try? JSON(data: data) else { return false }
        DispatchQueue.main.sync {
            self.hasFlag = jsonData["d"]["hasFlag"].boolValue
            self.ontime = jsonData["d"]["ontime"].boolValue
        }
        guard hasFlag != nil,
              ontime != nil else { return false }
        DispatchQueue.main.async { self.ncovState = .successed }
        return true
    }
}
