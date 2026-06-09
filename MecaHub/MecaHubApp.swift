//
//  MecaHubApp.swift
//  MecaHub
//
//  Created by LIC-N1 on 23/05/26.
//

import SwiftUI

@main
struct MecaHubApp: App {
    @StateObject var mecanicoVM = MecanicoViewModel()
    
    var body: some Scene {
        WindowGroup {
            if mecanicoVM.isLoggedIn {
                MainTabView(mecanicoVM: mecanicoVM)
            } else {
                LoginView()
                    .environmentObject(mecanicoVM)
            }
        }
    }
}
