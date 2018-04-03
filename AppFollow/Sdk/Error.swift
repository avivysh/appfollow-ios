//
//  Error.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 03/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: ApiError
}

struct ApiError: Decodable, LocalizedError {
    let message: String
    let code: Int
    let submessage: String
    let subcode: Int
    
    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case code
        case submessage = "submsg"
        case subcode = "subcode"
    }
    
    var errorDescription: String? {
        if submessage.isEmpty {
            return "\(message) [code:\(code)]"
        }
        return "\(submessage) [code:\(subcode)]"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try map.decode(.message) ?? ""
        self.code = try map.decode(.code) ?? 0
        self.submessage = try map.decodeIfPresent(.submessage) ?? ""
        self.subcode = try map.decodeIfPresent(.subcode) ?? 0
    }
}
