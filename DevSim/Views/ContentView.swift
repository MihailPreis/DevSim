//
//  ContentView.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State var simulators: LoadableResult<Simulators, Error> = .idle
    @State var selected: Simulator?
    
    var body: some View {
        NavigationSplitView {
            switch simulators {
            case .idle, .loading:
                ProgressView()
                
            case .success(let model):
                SimulatorsList(selected: $selected, model: model)
                
            case .failure(let error):
                Text("\(error)")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        } detail: {
            if let selected {
                SimulatorDetails(model: selected)
            } else {
                Text("Select simulator")
            }
        }
        .task(fetchSimulators)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Update simulators", systemImage: "arrow.clockwise") {
                    Task {
                        simulators = .loading
                        await fetchSimulators()
                    }
                }
            }
        }
    }
    
    @Sendable func fetchSimulators() async {
        simulators = .loading
        do {
            let result = try await ProcessHandler.default
                .run(process: .getSimulators)
                .convert(to: Simulators.self)
            
            simulators = .success(result)
        } catch {
            simulators = .failure(error)
        }
    }
}

#Preview {
    ContentView()
}
