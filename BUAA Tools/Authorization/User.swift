//
//  User.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import Foundation

class User : ObservableObject {
    var username: String = ""
    var password: String = ""
    var appLoginState: ActionState = .failed
    var ssoLoginState: ActionState = .failed
    @Published var loginState: ActionState = .failed
    @Published var refreshError: Bool = false // 改变这个值用于刷新视图
    
    static let defaultUser = User()
    
    private init() {
        username = UserDefaults.standard.string(forKey: UserProfile.username.rawValue) ?? ""
        password = UserDefaults.standard.string(forKey: UserProfile.password.rawValue) ?? ""
        Task { await User.defaultUser.login() }
    }

    func saveProfile() {
        UserDefaults.standard.set(username, forKey: UserProfile.username.rawValue)
        UserDefaults.standard.set(password, forKey: UserProfile.password.rawValue)
    }
    
    func logout() {
        username = ""
        password = ""
        appLoginState = .failed
        ssoLoginState = .failed
        loginState = .failed
        saveProfile()
        URLSession.shared.configuration.httpCookieStorage?.removeCookies(since: .distantPast)
    }
}
