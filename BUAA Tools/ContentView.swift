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
        user.loginState == .successed ? AnyView(
            TabView {
                HomeView().tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                ChartsView().tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Chart")
                }
            }
        ) : AnyView(LoginView())
    }
}
