import Foundation
import SwiftyJSON
import SwiftSoup

extension User {
    
    func login() async {
        DispatchQueue.main.async {
            if self.loginState != .successed {
                self.loginState = .excuting
            }
        }
        do {
            async let app = appLogin()
            async let sso = ssoLogin()
            let _ = try await app
            let _ = try await sso
        } catch (AppException.LoginFailed) {
            DispatchQueue.main.async {
                if self.loginState != .successed {
                    self.loginState = .failed
                } else {
                    self.refreshError = true
                }
            }
            return
        } catch (AppException.DoubleLogin) {
            DispatchQueue.main.async {
                if self.loginState != .successed {
                    self.loginState = .error
                } else {
                    self.refreshError = false
                }
            }
            return
        } catch {
            DispatchQueue.main.async {
                if self.loginState != .successed {
                    self.loginState = .error
                } else {
                    self.refreshError = true
                }
            }
            return
        }
        DispatchQueue.main.async {
            self.loginState = .successed
            self.refreshError = false
        }
        saveProfile()
    }
    
    private func appLogin() async throws -> Bool {
//        if appLoginState == .disable {
//            throw fatalError("method appLogin failed unexpectedly")
//        } // 直接失败
        if appLoginState == .excuting { 
            while appLoginState == .excuting {} // 死循环阻塞
            guard appLoginState == .successed else { throw AppException.LoginFailed }
            return true
        } // 防止重复调用
        defer {
            if appLoginState == .excuting {
                appLoginState = .failed
            }
        }
        appLoginState = .excuting
        var request = URLRequest(url: .appLoginURL)
        request.httpMethod = "POST"
        let body = [
            "username": username,
            "password": password
        ]
        request.httpBody = body.percentEncoded()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else {
            throw AppException.InternetError
        }
        let jsonData = try JSON(data: data)
        guard jsonData["e"] == 0 else { throw AppException.LoginFailed }
        appLoginState = .successed
        return true
    }
    
    private func ssoLoginExecution() async throws -> String {
        var request = URLRequest(url: .ssoLoginurl)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else {
            throw AppException.InternetError
        }
        guard let dataString = String(data: data, encoding: .utf8) else {
            throw AppException.InternetError
        }
        let doc = try SwiftSoup.parse(dataString)
        let elements = try doc.select("input").attr("name", "execution")
        var execution = ""
        elements.forEach { element in
            let value = (try? element.attr("value")) ?? ""
            if value.count > execution.count {
                execution = value
            }
        }
        return execution
    }
    
    private func ssoLogin() async throws -> Bool {
//        if ssoLoginState == .disable {
//            throw fatalError("method ssoLogin failed unexpectedly")
//        } // 直接失败
        if ssoLoginState == .excuting { 
            while ssoLoginState == .excuting {} // 死循环阻塞
            guard ssoLoginState == .successed else { throw AppException.LoginFailed }
            return true
        } // 防止重复调用
        defer {
            if ssoLoginState == .excuting {
                ssoLoginState = .failed
            }
        }
        ssoLoginState = .excuting
        let execution = try await ssoLoginExecution()
        guard execution != "" else { throw AppException.DoubleLogin }
        var request = URLRequest(url: .ssoLoginurl)
        let body = [
            "username": username,
            "password": password,
            "execution": execution,
            "_eventId": "submit"
        ]
        request.httpMethod = "POST"
        request.httpBody = body.percentEncoded()
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299) ~= httpResponse.statusCode else {
            throw AppException.InternetError
        }
        ssoLoginState = .successed
        return true
    }
}
