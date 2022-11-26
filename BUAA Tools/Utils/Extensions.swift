//
//  Extensions.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//

import Foundation

extension String {
    func toDouble() -> Double? {
        guard first != "." else { return nil }
        let filtered1 = filter { "0123456789.".contains($0) }
        guard filtered1 == self else { return nil }
        let filtered2 = filter { "0123456789".contains($0) }
        guard filtered1.count == filtered2.count ||
                filtered1.count == filtered2.count + 1
                else { return nil }
        return Double(self)
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.3f", self)
    }
}
