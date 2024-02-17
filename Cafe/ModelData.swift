//
//  ModelData.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import Foundation
import Combine
import SwiftUI

enum CurrentView: Int, Hashable, Equatable, CaseIterable {
    case `default`
    case scheduler
    case pidScheduler
    case dateScheduler
}

class ModelData: ObservableObject {
    @Published var isActive: Bool = false
    @Published var currentView: CurrentView = .default
    @Published private var schedulerPublishers: [ScheduleItem : AnyCancellable] = [:]
    
    private var viewSizes: [CurrentView : CGSize] = [
        .default: CGSize(width: 250, height: 300),
        .scheduler: CGSize(width: 300, height: 400),
        .pidScheduler: CGSize(width: 250, height: 250),
        .dateScheduler: CGSize(width: 250, height: 250)
    ]
    
    var scheduledItems: [ScheduleItem] {
        Array(schedulerPublishers.keys)
    }
    
    func schedule(activation: ScheduleItem.Activation, pid: UInt32) {
        let item = ScheduleItem(activation: activation, objective: .pid(pid))
        schedule(activation: activation, item: item)
    }
    
    func schedule(activation: ScheduleItem.Activation, date: Date) {
        let item = ScheduleItem(activation: activation, objective: .date(date))
        schedule(activation: activation, item: item)
    }
    
    func schedule(activation: ScheduleItem.Activation, item: ScheduleItem) {
        var item = item
        
        guard let publisher = item.activate() else {
            // TODO: Display error to user
            return
        }
        
        self.schedulerPublishers[item] = publisher.sink { _ in
            self.schedulerPublishers[item]?.cancel()
            item.deactivate()
            self.schedulerPublishers.removeValue(forKey: item)
            print("\(activation == .activate ? "Activated" : "Deactivated") by \(item)")
            self.isActive = activation == .activate
        }
    }
    
    func deactivateScheduledItem(item: inout ScheduleItem) {
        guard let cancellable = schedulerPublishers[item] else {
            return
        }
        
        schedulerPublishers.removeValue(forKey: item)
        
        cancellable.cancel()
        item.deactivate()
    }
    
    func viewSize(for viewCase: CurrentView) -> CGSize {
        switch viewCase {
        case .default:
            CGSize(width: 240, height: 250)
        case .scheduler:
            CGSize(width: 300, height: 400)
        case .pidScheduler:
            CGSize(width: 300, height: 250)
        case .dateScheduler:
            CGSize(width: 300, height: 250)
        }
    }
    
    func view(for viewCase: CurrentView) -> some View {
        switch viewCase {
        case .default:
            return AnyView(DefaultPopupView())
        case .scheduler:
            return AnyView(SchedulerView())
        case .pidScheduler:
            return AnyView(PIDSchedulerView())
        case .dateScheduler:
            return AnyView(DateSchedulerView())
        }
    }
}
