//
//  Id.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

private func decode(from decoder: Decoder) throws -> String {
    let container = try decoder.singleValueContainer()
    var id = ""
    if let value = try? container.decode(String.self) {
        id = value
    } else if let value = try? container.decode(Int.self) {
        id = String(value)
    }
    return id
}

protocol IdType : Codable, Hashable, CustomStringConvertible {
    var value: String { get }
    var isEmpty: Bool { get }
    init(value: String)
    init(from decoder: Decoder) throws
    func encode(to encoder: Encoder) throws
}

extension IdType {
    var description: String { return "\(self.value)" }

    var isEmpty: Bool {
        get { return self.value.isEmpty }
    }
    
    var hashValue: Int {
        return self.value.hashValue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}

struct ValueId: IdType {
    static let empty = ValueId(value: "")
    
    let value: String
    
    static func ==(lhs: ValueId, rhs: ValueId) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decode(from: decoder))
    }
}

struct UserId: IdType {
    static let empty = UserId(value: "")

    let value: String
    
    static func ==(lhs: UserId, rhs: UserId) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decode(from: decoder))
    }
}

struct ExtId: IdType {
    static let empty = ExtId(value: "")

    let value: String
    
    static func ==(lhs: ExtId, rhs: ExtId) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decode(from: decoder))
    }
    
    init(from value: Any) {
        if let number = value as? Int {
            self.init(value: String(number))
        } else if let str = value as? String {
            self.init(value: str)
        } else {
            self.init(value: "")
        }
    }
}

struct ReviewId: IdType {
    static let empty = ReviewId(value: "")

    let value: String
    
    static func ==(lhs: ReviewId, rhs: ReviewId) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decode(from: decoder))
    }
    
    init(from value: Any) {
        if let number = value as? Int {
            self.init(value: String(number))
        } else if let str = value as? String {
            self.init(value: str)
        } else {
            self.init(value: "")
        }
    }
}

struct AppId: IdType {
    static let empty = AppId(value: "")
    
    let value: String
    
    static func ==(lhs: AppId, rhs: AppId) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decode(from: decoder))
    }
}

struct CollectionId: IdType {
    static let empty = CollectionId(value: "")
    
    let value: String
    
    static func ==(lhs: CollectionId, rhs: CollectionId) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.init(value: try decode(from: decoder))
    }
}
