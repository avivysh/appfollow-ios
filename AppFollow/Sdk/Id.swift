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

protocol Id : Decodable, Hashable {
    var value: String { get }
    var isEmpty: Bool { get }
    init(value: String)
    init(from decoder: Decoder) throws
}

extension Id {
    var isEmpty: Bool {
        get { return self.value.isEmpty }
    }
    var hashValue: Int {
        return self.value.hashValue
    }
}

struct ValueId: Id {
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

struct UserId: Id {
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

struct ExtId: Id {
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
}

struct ReviewId: Id {
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
}

struct AppId: Id {
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

struct CollectionId: Id {
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
