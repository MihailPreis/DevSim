//
//  AppList.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import SwiftUI

struct AppList: View {
    @Binding var selected: AppInfo?
    let items: [AppInfo]
    
    var body: some View {
        List(selection: $selected) {
            ForEach(items, content: makeItem)
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
    }
    
    func makeItem(_ app: AppInfo) -> some View {
        Text(app.bundleIdentifier)
            .id(app)
    }
}

#Preview {
    AppList(selected: .constant(nil), items: [.mock(), .mock()])
}
