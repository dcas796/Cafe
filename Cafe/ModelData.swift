//
//  ModelData.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import Foundation
import Combine

class ModelData: ObservableObject {
    @Published var isActive: Bool = false
    @Published var currentView: CurrentView = .default
    @Published private var schedulerPublishers: [ScheduleItem : AnyCancellable] = [:]
    
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
}
