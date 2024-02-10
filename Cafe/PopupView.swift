//
//  PopupView.swift
//  Cafe
//
//  Created by Dani on 7/2/24.
//

import SwiftUI

enum CurrentView {
    case `default`
    case scheduler
    case pidScheduler
    case dateScheduler
}

struct PopupView: View {
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        switch model.currentView {
        case .default:
            DefaultPopupView()
        case .scheduler:
            SchedulerView()
        case .pidScheduler:
            PIDSchedulerView()
        case .dateScheduler:
            DateSchedulerView()
        }
    }
}

#Preview {
    PopupView()
        .environmentObject(ModelData())
}
