//
//  DeeplinkEditor.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import SwiftUI

struct DeeplinkEditor: View {
    @State private var sendingStatus: Loadable<Error> = .idle
    @State private var isValid: Bool = false
    @State private var deeplink: String = ""
    
    private let simulatorId: String
    private let bundleId: String
    private var defaultDeeplink: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Test deeplink")
                .font(.title)
            
            TextField("Deeplink", text: $deeplink, prompt: Text("scheme://path"))
            
            HStack {
                Button("Clear", systemImage: "trash.fill", role: .destructive) {
                    deeplink = defaultDeeplink
                    sendingStatus = .idle
                }
                
                Spacer()
                
                if isValid {
                    switch sendingStatus {
                    case .idle, .loading:
                        Text(" ")
                        
                    case .success:
                        Text("Deeplink success send")
                            .font(.callout)
                            .foregroundStyle(.green)
                            .lineLimit(1)
                        
                    case .failure(let failure):
                        Text("Error: \(failure)")
                            .font(.callout)
                            .foregroundStyle(.red)
                            .lineLimit(1)
                    }
                } else {
                    Text("Invalid url!")
                        .font(.callout)
                        .foregroundStyle(.red)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button("Send", systemImage: "paperplane.fill", action: sendPushNotification)
                    .disabled(!isValid)
            }
        }
        .task { deeplink = defaultDeeplink }
        .task(id: deeplink) {
            sendingStatus = .idle
            isValid = URL(string: deeplink) != nil
            UserDefaults.standard.set(deeplink, forKey: "deeplink.\(bundleId)")
        }
        .disabled(sendingStatus.isLoading)
        .overlay {
            if sendingStatus.isLoading {
                Color.gray.opacity(0.2)
                    .transition(.opacity)
                
                ProgressView()
                    .transition(.opacity)
            }
        }
    }
    
    init(simulatorId: String, bundleId: String, defaultDeeplink: String? = nil) {
        self.simulatorId = simulatorId
        self.bundleId = bundleId
        self.defaultDeeplink = UserDefaults.standard.string(forKey: "deeplink.\(bundleId)")
            ?? defaultDeeplink
            ?? "\(bundleId)://test"
    }
    
    private func sendPushNotification() {
        sendingStatus = .loading
        Task {
            do {
                try await ProcessHandler.default
                    .run(process: .openDeepLink(
                        simulatorId: simulatorId,
                        deepLink: deeplink
                    ))
                
                sendingStatus = .success
            } catch {
                sendingStatus = .failure(error)
            }
        }
    }
}

#Preview {
    DeeplinkEditor(simulatorId: "", bundleId: "")
}
