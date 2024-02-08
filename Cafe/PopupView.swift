//
//  PopupView.swift
//  Cafe
//
//  Created by Dani on 7/2/24.
//

import SwiftUI

struct PopupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {
                Text(isActive ? "Active" : "Inactive")
                    .font(.title3)
                    .bold()
                
                Image(systemName: isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                
                Toggle("", isOn: $isActive)
                    .toggleStyle(.switch)
            }
            .frame(width: 150)
            
            SettingsLink {
                Image(systemName: "gear")
            }
            .buttonStyle(.borderless)
        }
        .padding()
    }
}

#Preview {
    @State var isActive: Bool = false
    return PopupView(isActive: $isActive)
}
