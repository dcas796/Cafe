//
//  CafeApp.swift
//  Cafe
//
//  Created by Dani on 7/2/24.
//

import SwiftUI
import IOKit.pwr_mgt

@main
struct CafeApp: App {
    @State var isActive: Bool = false
    
    @State private var _assertionID: IOPMAssertionID = 0
    
    var body: some Scene {
        MenuBarExtra("Café", systemImage: isActive ? "cup.and.saucer.fill" : "cup.and.saucer") {
            PopupView(isActive: $isActive)
        }
        .menuBarExtraStyle(.window)
        .onChange(of: isActive, didChangeActivation)
        
        Settings {
            SettingsView()
        }
    }
    
    func didChangeActivation() {
        if isActive {
            guard disableSleep() else {
                isActive = false
                return
            }
        } else {
            enableSleep()
        }
    }
    
    func disableSleep() -> Bool {
        IOPMAssertionRelease(_assertionID)
        let result = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                    IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                    "Cafe is preventing your computer from sleeping." as CFString,
                                    &_assertionID)
        return result == kIOReturnSuccess
    }
    
    func enableSleep() {
        IOPMAssertionRelease(_assertionID)
    }
}
