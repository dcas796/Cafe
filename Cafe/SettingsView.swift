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
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
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
