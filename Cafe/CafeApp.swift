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
    @StateObject var model: ModelData = ModelData()
    
    @State private var _assertionID: IOPMAssertionID = 0
    
    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
    
    var body: some Scene {
        MenuBarExtra("Café", systemImage: model.isActive ? "cup.and.saucer.fill" : "cup.and.saucer") {
            PopupView()
                .environmentObject(model)
        }
        .menuBarExtraStyle(.window)
        .onChange(of: model.isActive, didChangeActivation)
        
        Settings {
            SettingsView()
        }
    }
    
    func didChangeActivation() {
        if model.isActive {
            guard disableSleep() else {
                // TODO: Find a way to roll back model.isActive without triggering .onChange(of:,_:)
                // model.isActive = false
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
