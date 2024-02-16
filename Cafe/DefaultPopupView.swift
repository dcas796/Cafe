//
//  DefaultPopupView.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import SwiftUI

struct DefaultPopupView: View {
    @EnvironmentObject var model: ModelData
    
    let titleAnimationOffset: CGFloat = 15
    let animationDuration: CGFloat = 0.2
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {
                ZStack {
                    Text("Active")
                        .font(.title3)
                        .bold()
                        .offset(x: 0, y: model.isActive ? 0 : -titleAnimationOffset)
                        .opacity(model.isActive ? 1 : 0)
                    
                    Text("Inactive")
                        .font(.title3)
                        .bold()
                        .offset(x: 0, y: model.isActive ? titleAnimationOffset : 0)
                        .opacity(model.isActive ? 0 : 1)
                }
                .animation(.smooth(duration: animationDuration), value: model.isActive)
                
                Spacer()
                
                Image(systemName: model.isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                    .animation(.smooth(duration: animationDuration), value: model.isActive)
                
                Spacer()
                
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
