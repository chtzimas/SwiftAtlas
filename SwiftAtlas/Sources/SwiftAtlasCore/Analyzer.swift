//
//  Analyzer.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/7/26.
//

import Foundation
import SwiftParser
import SwiftSyntax

public final class Analyzer {

    public init() {}

    public func analyze(filePath: String) throws -> SourceFileSyntax {
        let url = URL(fileURLWithPath: filePath)
        let content = try String(contentsOf: url, encoding: .utf8)
        let sourceFileSyntax = Parser.parse(source: content)

        return sourceFileSyntax
    }
}
