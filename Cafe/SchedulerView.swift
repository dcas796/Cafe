//
//  SchedulerView.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import SwiftUI

struct SchedulerView: View {
    @EnvironmentObject var model: ModelData
    
    @State var selectedItems: Set<ScheduleItem> = []
    
    let listBorderRadius: Double = 10
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Button {
                    model.currentView = .default
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
                .buttonStyle(.borderless)
            }
            
            VStack {
                Text("Scheduler")
                    .font(.title3)
                    .bold()
                
                List(selection: $selectedItems) {
                    ForEach(model.scheduledItems) { item in
                        Group {
                            switch item.objective {
                            case .pid(let pid):
                                Text("\(item.activation == .activate ? "Activate" : "Deactivate") when process with PID ") +
                                Text("\(pid)").monospaced() +
                                Text("\(item.name != nil ? " (\(item.name!))" : "") terminates")
                            case .date(let date):
                                Text("\(item.activation == .activate ? "Activate" : "Deactivate") at \(date)")
                            }
                        }
                        .tag(item)
                    }
                    .onDelete(perform: deleteItems)
                }
                .onDeleteCommand(perform: deleteSelection)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: listBorderRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: listBorderRadius)
                        .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                )
                
                Button("Add Schedule by PID") {
                    model.currentView = .pidScheduler
                }
                Button("Add Schedule by Date") {
                    model.currentView = .dateScheduler
                }
            }
        }
        .padding()
    }
    
    func deleteSelection() {
        for var item in selectedItems {
            model.deactivateScheduledItem(item: &item)
        }
    }
    
    func deleteItems(at indices: IndexSet) {
        for index in indices {
            var item = model.scheduledItems[index]
            model.deactivateScheduledItem(item: &item)
        }
    }
}

#Preview {
    SchedulerView()
        .environmentObject(ModelData())
}
