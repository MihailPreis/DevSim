//
//  SimulatorDetails.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import SwiftUI

struct SimulatorDetails: View {
    @State private var applications: LoadableResult<[AppInfo], Error> = .idle
    @State private var selected: AppInfo?
    
    let model: Simulator
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(model.name)
                    .font(.largeTitle)
                
                Spacer()
                
                Button("Open folder", systemImage: "folder.fill") {
                    NSWorkspace.shared.open(URL(filePath: model.dataPath))
                }
            }
            .padding([.horizontal, .top])
            
            Text(model.deviceTypeIdentifier)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding([.horizontal, .bottom])
            
            HSplitView {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    
                    switch applications {
                    case .idle, .loading:
                        ProgressView()
                        
                    case .success(let apps):
                        AppList(selected: $selected, items: apps)
                        
                    case .failure(let error):
                        Text(String(describing: error))
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button("Update", systemImage: "arrow.clockwise") {
                        Task { await fetchApplications() }
                    }
                    .buttonStyle(.link)
                    .padding(.vertical, 5)
                }
                .frame(minWidth: 100, idealWidth: 200, maxHeight: .infinity)
                
                VStack(spacing: 0) {
                    if let selected {
                        AppDetails(simulatorId: model.id, model: selected)
                    } else {
                        Text("Select app")
                    }
                }
                .frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task(fetchApplications)
    }
    
    @Sendable private func fetchApplications() async {
        applications = .loading
        do {
            let result = try await ProcessHandler.default
                .run(process: .getApplications(simulatorId: model.udid.uuidString))
            let items = try PropertyListDecoder().decode([String: AppInfo].self, from: result)
            applications = .success(Array(items.values).filter({ $0.applicationType == "User" }))
        } catch {
            applications = .failure(error)
        }
    }
}

#Preview {
    SimulatorDetails(model: .mock())
}
