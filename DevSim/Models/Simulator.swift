//
//  Simulator.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import Foundation

struct Simulators: Hashable, Decodable {
    let devices: [String: [Simulator]]
}

struct Simulator: Hashable, Decodable, Identifiable {
    let lastBootedAt: Date
    let dataPath: String
    let dataPathSize: Int64
    let udid: UUID
    let isAvailable: Bool
    let logPathSize: Int64
    let deviceTypeIdentifier: String
    let state: String
    let name: String
    
    var id: String { udid.uuidString }
    
    var isBooted: Bool {
        state == "Booted"
    }
}

// MARK: - Mock

extension Simulator {
    static func mock() -> Self {
        Simulator(
            lastBootedAt: .now,
            dataPath: "/",
            dataPathSize: 0,
            udid: UUID(),
            isAvailable: true,
            logPathSize: 0,
            deviceTypeIdentifier: UUID().uuidString,
            state: "Booted",
            name: "Test device"
        )
    }
}
