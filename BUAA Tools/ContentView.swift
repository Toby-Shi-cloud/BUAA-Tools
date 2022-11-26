//
//  ContentView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var user = User.defaultUser
    
    var body: some View {
        user.loginState == .successed ? AnyView(HomeView()) : AnyView(LoginView())
    }
}
