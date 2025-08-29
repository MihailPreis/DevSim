//
//  String+Format.swift
//  DevSim
//
//  Created by Mike Price on 29.08.2025.
//

import Foundation

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var formattedIdentifier: String {
        guard let last = split(separator: ".").last else {
            return self
        }
        
        var result = ""
        var isDigitLast = false
        
        for (index, item) in last.split(separator: "-").enumerated() {
            let spacer = index == 0 ? "" : " "
            
            if String(item).isNumber {
                if isDigitLast {
                    result += "." + String(item)
                } else {
                    result += spacer + String(item)
                }
                
                isDigitLast = true
            } else {
                result += spacer + String(item)
                isDigitLast = false
            }
        }
        
        return result
    }
}
