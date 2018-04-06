//
//  Types.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 03/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

private func decodeDouble(from decoder: Decoder) throws -> Double {
    let container = try decoder.singleValueContainer()
    if let value = try? container.decode(String.self) {
        return Double(value) ?? 0
    } else if let value = try? container.decode(Double.self) {
        return value
    }
    return 0
}

private func decodeInt(from decoder: Decoder) throws -> Int {
    let container = try decoder.singleValueContainer()
    if let value = try? container.decode(String.self) {
        return Int(value) ?? 0
    } else if let value = try? container.decode(Int.self) {
        return value
    }
    return 0
}

private func decodeBool(from decoder: Decoder) throws -> Bool {
    let value = try decodeInt(from: decoder)
    return value == 1
}

protocol ParseType: Decodable, Hashable, CustomStringConvertible {
    associatedtype ValueType: Hashable
    var value: ValueType { get }
    init(value: ValueType)
    init(from decoder: Decoder) throws
}

extension ParseType {
    var description: String { return "\(self.value)" }
    var hashValue: Int { return self.value.hashValue }
}
struct DoubleValue: ParseType {
    static let `zero` = DoubleValue(value: 0)
    
    let value: Double
    
    static func ==(lhs: DoubleValue, rhs: DoubleValue) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: Double) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decodeDouble(from: decoder))
    }
}

struct IntValue: ParseType {
    static let `zero` = IntValue(value: 0)
    
    let value: Int
    
    static func ==(lhs: IntValue, rhs: IntValue) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: Int) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decodeInt(from: decoder))
    }
    
}
struct BoolValue: ParseType {
    static let `false` = BoolValue(value: false)
    
    let value: Bool
    
    static func ==(lhs: BoolValue, rhs: BoolValue) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: Bool) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decodeBool(from: decoder))
    }
    
    var description: String { return self.value ? "Yes" : "No" }
}
