//
//  DefaultPopupView.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import SwiftUI

struct DefaultPopupView: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {
                Text(model.isActive ? "Active" : "Inactive")
                    .font(.title3)
                    .bold()
                
                Image(systemName: model.isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                
                VStack {
                    Toggle(isOn: $model.isActive) {
                        EmptyView()
                    }
                    .toggleStyle(.switch)
                    
                    Button("Schedule") {
                        model.currentView = .scheduler
                    }
                    .buttonStyle(.borderless)
                }
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
    DefaultPopupView()
        .environmentObject(ModelData())
}
