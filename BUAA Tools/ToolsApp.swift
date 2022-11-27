//
//  ToolsApp.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import SwiftUI

@main
struct ToolsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: scenePhase) { value in
            if value == .active {
                UserData.dataModel.createPersistentContainer()
            }
        }
    }
}
