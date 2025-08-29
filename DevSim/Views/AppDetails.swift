//
//  AppDetails.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import SwiftUI

struct AppDetails: View {
    let simulatorId: String
    let model: AppInfo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    HStack {
                        AsyncImage(url: URL(fileURLWithPath: model.path + "/AppIcon60x60@2x.png")) { image in
                            image
                                .resizable()
                                .frame(width: 44, height: 44)
                                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.gray)
                                .frame(width: 44, height: 44)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(model.bundleDisplayName)
                                .font(.largeTitle)
                            
                            Text(model.bundleIdentifier)
                                .font(.subheadline)
                        }
                    }
                    
                    Spacer()
                    
                    Button("Bundle", systemImage: "folder.fill") {
                        NSWorkspace.shared.activateFileViewerSelecting([
                            URL(fileURLWithPath: "\(model.path)/\(model.bundleExecutable)")
                        ])
                    }
                }
                
                Divider()
                
                PushEditor(simulatorId: simulatorId, bundleId: model.bundleIdentifier)
                
                Divider()
                
                DeeplinkEditor(simulatorId: simulatorId, bundleId: model.bundleIdentifier)
            }
            .padding([.horizontal, .bottom])
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    AppDetails(simulatorId: "", model: .mock())
}
