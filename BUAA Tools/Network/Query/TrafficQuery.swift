import Foundation
import RegexBuilder

class Traffic : ObservableObject {
    // 对应三种不同流量，未知时保持 nil
    @Published var freeTraffic: (tot: Double, res: Double)? = nil
    @Published var giftTraffic: (tot: Double, res: Double)? = nil
    @Published var paidTraffic: Double? = nil
    @Published var trafficState: ActionState = .failed
    
    init() {}
    
    // 这个构造函数只用于 Preview
    init(freeTraffic: (tot: Double, res: Double)?, giftTraffic: (tot: Double, res: Double)?, paidTraffic: Double?) {
        self.freeTraffic = freeTraffic
        self.giftTraffic = giftTraffic
        self.paidTraffic = paidTraffic
        self.trafficState = .disable // 调用 query 时 触发随机更新
    }
    
    func asyncQuery(user: User) -> Traffic {
        Task { await query(user: user) }
        return self
    }
    
    func query(user : User) async -> Bool {
        if trafficState == .disable {
            if self.freeTraffic != nil {
                self.freeTraffic!.res = Double.random(in: 0.0...30.0)
            }
            if self.giftTraffic != nil {
                self.giftTraffic!.res = Double.random(in: 0.0...70.0)
            }
            return true
        }
        if trafficState == .excuting { return false } // 防止重复调用
        defer {
            DispatchQueue.main.async {
                if self.trafficState == .excuting {
                    self.trafficState = .failed
                }
            }
        }
        DispatchQueue.main.async { self.trafficState = .excuting }
        if user.loginState != .successed {
            while user.loginState == .excuting {}
            guard user.loginState == .successed else { return false }
        }
        guard let (data, response) = try? await URLSession.shared.data(from: .trafficURL) else { return false }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else { return false }
        guard let dataString = String(data: data, encoding: .utf8) else { return false }
        
        let span = Regex {
            One(#"<span>"#)
            Capture { ZeroOrMore(.any, .reluctant) }
            One(#"</span>"#)
        }
        let commment = try! Regex(#"<!--.*?-->\s*<!--.*?-->"#)
        let chinese = UnicodeScalar(UInt16(0x4000))!...UnicodeScalar(UInt16(0x9fff))!
        let pattern = Regex {
            One(#"<div class="btn">"#)
            Capture { ZeroOrMore(chinese, .reluctant) }
            One(#"<br>"#)
            ZeroOrMore(.whitespace)
            ChoiceOf {
                span
                commment
            }
            ZeroOrMore(.whitespace)
            span
        }
        
        let toDouble = { (str: String) -> Double? in
            let suf = str.split(separator: "：").last
            let val = suf?.filter { "0123456789.".contains($0) }
            return Double(val ?? "")
        }
        
        for item in dataString.matches(of: pattern) {
            let name = String(item.output.1)
            if name.hashValue == "免费流量".hashValue {
                let tot = toDouble(String(item.output.2 ?? ""))
                let use = toDouble(String(item.output.3))
                if let tot = tot, let use = use {
                    DispatchQueue.main.async { self.freeTraffic = (tot: tot, res: tot - use) }
                } else {
                    DispatchQueue.main.async { self.freeTraffic = nil }
                }
            } else if name.hashValue == "赠送流量".hashValue {
                let tot = toDouble(String(item.output.2 ?? ""))
                let res = toDouble(String(item.output.3))
                if let tot = tot, let res = res {
                    DispatchQueue.main.async { self.giftTraffic = (tot: tot, res: res) }
                } else {
                    DispatchQueue.main.async { self.giftTraffic = nil }
                }
            } else if name.hashValue == "计费流量".hashValue {
                let res = toDouble(String(item.output.3))
                DispatchQueue.main.async { self.paidTraffic = res }
            }
        }
        DispatchQueue.main.async { self.trafficState = .successed }
//        print("Traffic OK!")
        return true
    }
}
