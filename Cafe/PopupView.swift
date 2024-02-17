//
//  PopupView.swift
//  Cafe
//
//  Created by Dani on 7/2/24.
//

import SwiftUI

struct PopupView: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        ZStack {
            ForEach(CurrentView.allCases, id: \.self) { viewCase in
                model.view(for: viewCase)
                        .offset(x: -400 * CGFloat(model.currentView.rawValue - viewCase.rawValue))
                        .opacity(model.currentView == viewCase ? 1 : 0)
            }
        }
        .frame(width: model.viewSize(for: model.currentView).width,
               height: model.viewSize(for: model.currentView).height)
        .animation(.smooth(duration: 0.2), value: model.currentView)
    }
}

#Preview {
    PopupView()
        .environmentObject(ModelData())
}
