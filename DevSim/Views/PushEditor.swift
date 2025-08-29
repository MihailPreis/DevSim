//
//  PushEditor.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import SwiftUI

struct PushEditor: View {
    static let defaultPayload: String = """
    {
      "aps": {
        "alert": {
          "title": "Title",
          "body": "Body"
        },
        "badge": 3,
        "sound": "default"
      }
    }
    """
    
    @State private var sendingStatus: Loadable<Error> = .idle
    @State private var pushPayload: String = ""
    
    private let simulatorId: String
    private let bundleId: String
    private let defaultPayload: String
    
    init(simulatorId: String, bundleId: String, defaultPayload: String = PushEditor.defaultPayload) {
        self.simulatorId = simulatorId
        self.bundleId = bundleId
        self.defaultPayload = UserDefaults.standard.string(forKey: "pushPayload.\(bundleId)") ?? defaultPayload
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Test push notification")
                .font(.title)
            
            TextEditor(text: $pushPayload)
                .frame(maxWidth: .infinity, minHeight: 150)
            
            HStack {
                Button("Clear", systemImage: "trash.fill", role: .destructive) {
                    pushPayload = defaultPayload
                    sendingStatus = .idle
                }
                
                Spacer()
                
                switch sendingStatus {
                case .idle, .loading:
                    Text(" ")
                    
                case .success:
                    Text("Push success send")
                        .font(.callout)
                        .foregroundStyle(.green)
                        .lineLimit(1)
                    
                case .failure(let failure):
                    Text("Error: \(failure)")
                        .font(.callout)
                        .foregroundStyle(.red)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button("Send", systemImage: "paperplane.fill", action: sendPushNotification)
            }
        }
        .task { pushPayload = defaultPayload }
        .task(id: pushPayload) {
            sendingStatus = .idle
            UserDefaults.standard
                .set(pushPayload, forKey: "pushPayload.\(bundleId)")
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
    
    private func sendPushNotification() {
        sendingStatus = .loading
        Task {
            let tempFileURL = FileManager.default
                .temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(".apns")
            
            defer {
                try? FileManager.default.removeItem(at: tempFileURL)
            }
            
            do {
                try pushPayload.write(to: tempFileURL, atomically: true, encoding: .utf8)
                
                try await ProcessHandler.default
                    .run(process: .sendPushNotification(
                        simulatorId: simulatorId,
                        bundleId: bundleId,
                        payloadFile: tempFileURL
                    ))
                
                sendingStatus = .success
            } catch {
                sendingStatus = .failure(error)
            }
        }
    }
}

#Preview {
    PushEditor(simulatorId: "", bundleId: "")
}
