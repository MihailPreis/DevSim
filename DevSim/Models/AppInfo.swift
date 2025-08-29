//
//  AppInfo.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import Foundation

struct AppInfo: Decodable, Hashable, Identifiable {
    let applicationType: String
    let bundle: String
    let bundleDisplayName: String
    let bundleExecutable: String
    let bundleIdentifier: String
    let bundleName: String
    let bundleVersion: String
    let dataContainer: String?
    let groupContainers: [String: String]?
    let path: String
    let appTags: [String]?
    
    var id: String { bundleIdentifier }
    
    enum CodingKeys: String, CodingKey {
        case applicationType = "ApplicationType"
        case bundle = "Bundle"
        case bundleDisplayName = "CFBundleDisplayName"
        case bundleExecutable = "CFBundleExecutable"
        case bundleIdentifier = "CFBundleIdentifier"
        case bundleName = "CFBundleName"
        case bundleVersion = "CFBundleVersion"
        case dataContainer = "DataContainer"
        case groupContainers = "GroupContainers"
        case path = "Path"
        case appTags = "SBAppTags"
    }
}

// MARK: - Mock

extension AppInfo {
    static func mock() -> Self {
        AppInfo(
            applicationType: "User",
            bundle: "file:///",
            bundleDisplayName: "Some app",
            bundleExecutable: "App",
            bundleIdentifier: "com.example.\(UUID().uuidString)",
            bundleName: "App",
            bundleVersion: "1",
            dataContainer: "file:///",
            groupContainers: nil,
            path: "/",
            appTags: nil
        )
    }
}
