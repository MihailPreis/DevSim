//
//  Loadable.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import Foundation

enum LoadableResult<Item: Hashable, Failure: Error> {
    case idle
    case loading
    case success(Item)
    case failure(Failure)
}

enum Loadable<Failure: Error> {
    case idle
    case loading
    case success
    case failure(Failure)
    
    var isLoading: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }
}
