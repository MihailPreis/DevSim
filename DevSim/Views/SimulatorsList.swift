//
//  SimulatorsList.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import SwiftUI

struct SimulatorsList: View {
    @Binding private var selected: Simulator?
    private let items: [(sdkId: String, simulator: [Simulator])]
    
    var body: some View {
        List(selection: $selected) {
            ForEach(items, id: \.sdkId) { sdkId, simulators in
                if !simulators.isEmpty {
                    Section(sdkId.formattedIdentifier) {
                        ForEach(simulators, content: makeItem)
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
    
    init(selected: Binding<Simulator?>, model: Simulators) {
        self._selected = selected
        self.items = model.devices.keys
            .sorted(by: <)
            .compactMap { key in
                model.devices[key].flatMap { (key, $0) }
            }
    }
    
    private func makeItem(_ item: Simulator) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(item.name)
                .font(.headline)
            
            HStack {
                Circle()
                    .fill(item.isAvailable ? .green : .red)
                    .frame(width: 8, height: 8)
                
                Text(item.deviceTypeIdentifier.formattedIdentifier)
                    .font(.subheadline)
            }
        }
        .id(item)
    }
}

#Preview {
    SimulatorsList(selected: .constant(nil), model: Simulators(
        devices: [
            "com.apple.CoreSimulator.SimRuntime.iOS-18-5": [.mock(), .mock()],
            "com.apple.CoreSimulator.SimRuntime.iOS-17-5": [.mock()],
            "com.apple.CoreSimulator.SimRuntime.iOS-17-6": []
        ]
    ))
}
