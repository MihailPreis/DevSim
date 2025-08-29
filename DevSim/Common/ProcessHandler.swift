//
//  ProcessHandler.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import Foundation

extension ProcessHandler {
    static let `default` = ProcessHandler(executableURL: URL(fileURLWithPath: "/bin/zsh"), launchPath: "/usr/bin/env")
}

extension ProcessHandler.ProcessCommand {
    static let getSimulators = ProcessHandler.ProcessCommand(arguments: ["xcrun", "simctl", "list", "devices", "booted", "-j"])
    
    static func getApplications(simulatorId: String) -> Self {
        ProcessHandler.ProcessCommand(arguments: ["xcrun", "simctl", "listapps", simulatorId])
    }
    
    static func sendPushNotification(simulatorId: String, bundleId: String, payloadFile: URL) -> Self {
        ProcessHandler.ProcessCommand(arguments: ["xcrun", "simctl", "push", simulatorId, bundleId, payloadFile.path])
    }
    
    static func openDeepLink(simulatorId: String, deepLink: String) -> Self {
        ProcessHandler.ProcessCommand(arguments: ["xcrun", "simctl", "openurl", simulatorId, deepLink])
    }
}

struct ProcessHandler {
    let executableURL: URL
    let launchPath: String
    
    struct ProcessCommand {
        typealias Argument = String
        var arguments: [Argument]
    }
    
    enum ProcessError: Error {
        case failure(code: Int32, reason: String?)
    }
    
    @MainActor
    @discardableResult
    func run(process: ProcessCommand) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation  in
            DispatchQueue.global(qos: .userInitiated)
                .async {
                    let task = Process()
                    let pipe = Pipe()
                    let errorPipe = Pipe()
                    
                    task.standardOutput = pipe
                    task.arguments = process.arguments
                    task.executableURL = executableURL
                    task.launchPath = launchPath
                    task.standardError = errorPipe
                    
                    do {
                        try task.run()
                        task.waitUntilExit()
                        guard task.terminationStatus == EXIT_SUCCESS else {
                            throw ProcessError.failure(code: task.terminationStatus, reason: nil)
                        }
                        let data = pipe.fileHandleForReading.readDataToEndOfFile()
                        continuation.resume(returning: data)
                    } catch {
                        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                        let errorString = String(data: errorData, encoding: .utf8)
                        let returnCode = task.terminationStatus
                        continuation.resume(throwing: ProcessError.failure(code: returnCode, reason: errorString))
                    }
                }
        }
    }
}
