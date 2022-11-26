//
//  LoginView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var user = User.defaultUser
    @State private var showAlert = false
    @State private var showAlertMsgIdx = 0
    private static let alertTitle = ["登录成功", "登录失败", "登录失败", "登录失败"]
    private static let alertMsg = ["恭喜🎉！登录成功！", "登录失败！请检查用户名和密码并再试一次！", "网络错误！请检查网络连接后再试！", "未知错误！请再试一次！"]
    
    var body: some View {
        ZStack {
            BackgoundView().opacity(0.3)
            VStack {
                Text("登录")
                    .font(.title)
                    .padding(30)
                
                GroupBox {
                    TextField("学号", text: $user.username)
                        .frame(width: 270, height: 20)
                        .font(.system(size: 16))
                        .keyboardType(.default)
                }
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 0.5).foregroundColor(Color.purple))
                .backgroundStyle(.clear)
                GroupBox {
                    SecureField("密码", text: $user.password)
                        .frame(width: 270, height: 20)
                        .font(.system(size: 16))
                        .keyboardType(.default)
                }
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 0.5).foregroundColor(Color.purple))
                .backgroundStyle(.clear)
                
                Button(action: {
                    Task {
                        await user.login()
                        DispatchQueue.main.async {
                            switch self.user.loginState {
                            case .successed: self.showAlert = false
                            case .failed: self.showAlert = true; self.showAlertMsgIdx = 1
                            case .error: self.showAlert = true; self.showAlertMsgIdx = 2
                            default: self.showAlert = true; self.showAlertMsgIdx = 3
                            }
                        }
                    }
                }) {
                    Text(user.loginState == .excuting ? "登录中……" : "登录")
                        .frame(width: 300, height: 50)
                        .font(.system(size: 16))
                        .foregroundColor(Color.purple)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 0.5).foregroundColor(Color.purple))
                }
                .disabled(user.loginState == .excuting)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(LoginView.alertTitle[showAlertMsgIdx]),
                        message: Text(LoginView.alertMsg[showAlertMsgIdx]),
                        dismissButton: .default(Text("好"), action: { self.showAlert = false })
                    )
                }
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}




