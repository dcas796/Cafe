//
//  CafeApp.swift
//  Cafe
//
//  Created by Dani on 7/2/24.
//

import SwiftUI

@main
struct CafeApp: App {
    @State var isActive: Bool = false
    
    var body: some Scene {
        MenuBarExtra("Café", systemImage: isActive ? "cup.and.saucer.fill" : "cup.and.saucer") {
            PopupView(isActive: $isActive)
        }
        .menuBarExtraStyle(.window)
        
        Settings {
            SettingsView()
        }
    }
}
