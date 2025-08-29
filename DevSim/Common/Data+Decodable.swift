//
//  Data+Decodable.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import Foundation

extension Data {
    func convert<T: Decodable>(to type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: self)
    }
}
