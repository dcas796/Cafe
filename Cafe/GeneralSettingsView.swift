//
//  GeneralSettingsView.swift
//  Cafe
//
//  Created by Dani on 8/2/24.
//

import SwiftUI
import ServiceManagement

fileprivate struct SettingsError: LocalizedError {
    var errorDescription: String?
    var failureReason: String?
    var helpAnchor: String?
    var recoverySuggestion: String?
    
    init(_ error: Error) {
        self.errorDescription = error.localizedDescription
    }
    
    init(localized: LocalizedError) {
        self.errorDescription = localized.errorDescription
        self.failureReason = localized.failureReason
        self.helpAnchor = localized.helpAnchor
        self.recoverySuggestion = localized.recoverySuggestion
    }
}

struct GeneralSettingsView: View {
    @State var launchesAtLogin: Bool = false
    
    @State private var isErrorPresent: Bool = false
    @State private var error: SettingsError?
    
    @State private var _timer: Timer?
    
    var body: some View {
        Toggle("Launches Automatically at Login", 
               isOn: Binding(get: { launchesAtLogin }, set: updateLaunchesAtLogin))
            .padding()
            .onAppear {
                _timer = Timer.scheduledTimer(
                    withTimeInterval: 1,
                    repeats: true) { _ in
                        if SMAppService.mainApp.status == .enabled {
                            launchesAtLogin = true
                        } else {
                            launchesAtLogin = false
                        }
                    }
                
                _timer?.fire()
            }
            .alert(isPresented: $isErrorPresent, error: error) {
                Button("OK", role: .cancel) {}
            }
    }
    
    func updateLaunchesAtLogin(newValue: Bool) {
        self.launchesAtLogin = newValue
        do {
            if launchesAtLogin {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            if let error = error as? LocalizedError {
                self.error = SettingsError(localized: error)
            } else {
                self.error = SettingsError(error)
            }
            self.isErrorPresent = true
            
            self.launchesAtLogin.toggle()
        }
    }
}

#Preview {
    GeneralSettingsView()
}
