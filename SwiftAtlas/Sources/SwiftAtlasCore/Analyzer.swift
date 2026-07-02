//
//  Analyzer.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/7/26.
//

import Foundation

public final class Analyzer {

    public init() {}

    public func analyze(filePath: String) throws -> String {
        let url = URL(fileURLWithPath: filePath)
        let content = try String(contentsOf: url)

        return "Read file with \(content.count) characters"
    }
}
