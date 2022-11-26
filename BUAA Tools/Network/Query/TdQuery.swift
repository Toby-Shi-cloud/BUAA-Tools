import Foundation
import RegexBuilder

class TdLine : ObservableObject {
    @Published var tdValue : [(term: String, value: Int)] = []
    @Published var tdState: ActionState = .failed
    private var tdLoginState: ActionState = .failed

    init() {}
    
    init(tdValue: [(term: String, value: Int)]) {
        self.tdValue = tdValue
        self.tdState = .disable
    }
    
    func asyncQuery(user: User) -> TdLine {
        Task { await query(user: user) }
        return self
    }
    
    private func tdLogin(user: User) async -> Bool {
        if user.loginState != .successed {
            tdLoginState = .failed
            while user.loginState == .excuting {}
            guard user.loginState == .successed else { return false }
        }
        if tdLoginState == .successed { return true }
        guard let (_, response) = try? await URLSession.shared.data(from: .tdLoginURL) else { return false }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else { return false }
        tdLoginState = .successed
        return true
    }
    
    func query(user: User) async -> Bool {
        if tdState == .disable {
            tdValue = tdValue.map { (term, _) in
                return (term: term, value: Int.random(in: 0...48))
            }
            return true
        }
        if tdState == .excuting { return false } // 防止重复调用
        defer {
            DispatchQueue.main.async {
                if self.tdState == .excuting {
                    self.tdState = .failed
                }
            }
        }
        DispatchQueue.main.async { self.tdState = .excuting }
        guard await tdLogin(user: user) else { return false }
        guard let (data, response) = try? await URLSession.shared.data(from: .tdURL) else { return false }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else { return false }
        guard let dataString = String(data: data, encoding: .utf8) else { return false }
        
        let pattern = Regex {
            "<td>"
            Capture(OneOrMore(.digit)) // 学年开始
            "-"
            Capture(OneOrMore(.digit)) // 学年结束
            "</td>"
            ZeroOrMore(.whitespace)
            "<td>"
            Capture(OneOrMore(.digit)) // 学期编号
            "</td>"
            ZeroOrMore(.whitespace)
            "<td>"
            Capture(OneOrMore(.digit)) // TD 次数
            "</td>"
            ZeroOrMore(.whitespace)
            "<td>-</td>"
        }
        
        var tds: [tdObject] = []
        for item in dataString.matches(of: pattern) {
            let term_st = Int(item.output.1)!
            let term_ed = Int(item.output.2)!
            let term_sel = Int(item.output.3)!
            let value = Int(item.output.4)!
            tds.append(tdObject(term_st: term_st, term_ed: term_ed, term_sel: term_sel, value: value))
        }
        tds.sort(by: >)
        tds.forEach { td in
            if let term = td.termToString() {
                DispatchQueue.main.async { self.tdValue.append((term: term, value: td.value)) }
            }
        }
        DispatchQueue.main.async { self.tdState = .successed }
        return true
    }
}

struct tdObject {
    let term_st: Int
    let term_ed: Int
    let term_sel: Int
    let value: Int
    
    static func < (left: tdObject, right: tdObject) -> Bool {
        if (left.term_st == right.term_st) { return left.term_st < right.term_st }
        if (left.term_ed == right.term_ed) { return left.term_ed < right.term_ed }
        if (left.term_sel == right.term_sel) { return left.term_sel < right.term_sel }
        if (left.value == right.value) { return left.value < right.value }
        return false
    }
    
    static func > (left: tdObject, right: tdObject) -> Bool {
        if (left.term_st == right.term_st) { return left.term_st > right.term_st }
        if (left.term_ed == right.term_ed) { return left.term_ed > right.term_ed }
        if (left.term_sel == right.term_sel) { return left.term_sel > right.term_sel }
        if (left.value == right.value) { return left.value > right.value }
        return false
    }
    
    private static let REFLECT = [1: "秋季学期", 2: "春季学期", 3: "夏季学期"]
    func termToString() -> String? {
        guard let term = tdObject.REFLECT[term_sel] else { return nil }
        return "\(term_st)-\(term_ed) " + term
    }
}
