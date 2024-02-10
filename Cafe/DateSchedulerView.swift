//
//  DateSchedulerView.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import SwiftUI

struct DateSchedulerView: View {
    @EnvironmentObject var model: ModelData
    
    @State var activation: ScheduleItem.Activation = .deactivate
    @State var date: Date = {
        var date = Date.now
        let calendar = Calendar.current
        let seconds = calendar.component(.second, from: date)
        return date.addingTimeInterval(TimeInterval(-seconds))
    }()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button {
                model.currentView = .scheduler
            } label: {
                Label("Back", systemImage: "chevron.left")
            }
            .buttonStyle(.borderless)
            
            VStack {
                Text("Schedule by Date")
                    .font(.title3)
                    .bold()
                
                // TODO: Add seconds column
                DatePicker("Date", selection: $date)
                
                Picker("Activation", selection: $activation) {
                    Text("Activate")
                        .tag(ScheduleItem.Activation.activate)
                    Text("Deactivate")
                        .tag(ScheduleItem.Activation.deactivate)
                }
                .pickerStyle(.inline)
                
                Button("Add") {
                    model.schedule(activation: activation, date: date)
                    model.currentView = .scheduler
                }
            }
            .frame(minWidth: 250)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    DateSchedulerView()
        .environmentObject(ModelData())
}
