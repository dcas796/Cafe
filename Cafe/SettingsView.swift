//
//  SettingsView.swift
//  Cafe
//
//  Created by Dani on 8/2/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Group {
                GeneralSettingsView()
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
            }
            .navigationTitle("Café Settings")
        }
        .frame(minWidth: 250,
               maxWidth: .infinity,
               minHeight: 100,
               maxHeight: .infinity)
    }
}

#Preview {
    SettingsView()
}
