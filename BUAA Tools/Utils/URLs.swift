//
//  URLs.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import Foundation

extension URL {
    static let appLoginURL = URL(string: "https://app.buaa.edu.cn/uc/wap/login/check")!
    static let ssoLoginurl = URL(string: "https://sso.buaa.edu.cn/login")!
    static let tdLoginURL = URL(string: "http://10.212.28.38/index.php?schoolno=10006")!
    static let tdURL = URL(string: "http://10.212.28.38/main.php?module=stu&title=stu_sun_score")!
    static let trafficURL = URL(string: "https://app.buaa.edu.cn/buaanet/wap/default/index")!
    static let ncovURL = URL(string: "https://app.buaa.edu.cn/buaaxsncov/wap/default/get-info")!
    static let ncovWebURL = URL(string: "https://app.buaa.edu.cn/site/buaaStudentNcov/index")!
    static let balanceLoginURL = URL(string: "https://sso.buaa.edu.cn/login?service=https%3A%2F%2Fpass.cc-pay.cn%2Flogin")!
    static func getBalanceURL(username: String) -> URL {
        return URL(string: "https://pass.cc-pay.cn/api/campus_card/balance?t=\(Int(Date().timeIntervalSince1970 * 1000))&stuNo=\(username)")!
    }
    static let balanceWebURL = URL(string: "https://pass.cc-pay.cn/mcampcard")!
    static let queueWebURL = URL(string: "https://jinshuju.net/f/jo5PqB?submit_link_generated_from=poster")!
}
