//
//  String.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 28/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

private let translit: [Character: String] = [
    "а": "a",
    "б": "b",
    "в": "v",
    "г": "g",
    "д": "d",
    "е": "e",
    "ж": "zh",
    "з": "z",
    "и": "i",
    "й": "j",
    "к": "k",
    "л": "l",
    "м": "m",
    "н": "n",
    "о": "o",
    "п": "p",
    "р": "r",
    "с": "s",
    "т": "t",
    "у": "u",
    "ф": "f",
    "х": "h",
    "ц": "c",
    "ч": "ch",
    "ш": "sh",
    "щ": "sch",
    "ь": "",
    "ъ": "",
    "ю": "ju",
    "я": "ya",
    "ы": "y"
]

private let cyrillicUpper = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЪЫЮЯ"
private let cyrillicLower = "абвгдежзийклмнопрстуфхцчшщьъыюя"

extension String {
    var safeJavaScript: String {
        var output = self.replacingOccurrences(of: "\\", with: "\\\\")
        output = output.replacingOccurrences(of: "\"", with: "\\\"")
        output = output.replacingOccurrences(of: "'", with: "\\'")
        return output.replacingOccurrences(of: "/", with: "\\/")
    }
    
    var toTranslit: String {
        var result = ""
        for c in self {
            if let t = translit[c] {
                if !t.isEmpty {
                    if (cyrillicUpper.contains(c)) {
                        result.append(t.uppercased())
                    } else {
                        result.append(t)
                    }
                }
            } else {
                result.append(c)
            }
            
        }
        return result
    }
    
    func matches(for regex: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        let matches: [[String]] = results.map {
            var strings = [String]()
            for i in 0 ..< $0.numberOfRanges {
                let rangeValue = String(self[Range($0.range(at: i), in: self)!])
                strings.append(rangeValue)
            }
            return strings
        }
        return matches.flatMap({ $0 })
    }
}
