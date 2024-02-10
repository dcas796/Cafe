//
//  PIDSchedulerView.swift
//  Cafe
//
//  Created by Dani on 10/2/24.
//

import SwiftUI

struct PIDSchedulerView: View {
    @EnvironmentObject var model: ModelData
    
    @State var activation: ScheduleItem.Activation = .deactivate
    @State var pid: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button {
                model.currentView = .scheduler
            } label: {
                Label("Back", systemImage: "chevron.left")
            }
            .buttonStyle(.borderless)
            
            VStack {
                Text("Schedule by PID")
                    .font(.title3)
                    .bold()
                
                TextField("PID", text: $pid)
                    .frame(maxWidth: 75)
                
                Picker("Activation", selection: $activation) {
                    Text("Activate")
                        .tag(ScheduleItem.Activation.activate)
                    Text("Deactivate")
                        .tag(ScheduleItem.Activation.deactivate)
                }
                .pickerStyle(.inline)
                
                Button("Add") {
                    guard let pid = UInt32(pid) else {
                        return
                    }
                    model.schedule(activation: activation, pid: pid)
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
    PIDSchedulerView()
        .environmentObject(ModelData())
}
