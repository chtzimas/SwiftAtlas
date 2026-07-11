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

    public func analyze(filePath: String) throws -> [String] {

        let url = URL(fileURLWithPath: filePath)
        let content = try String(contentsOf: url, encoding: .utf8)

        let sourceFile = Parser.parse(source: content)

        let visitor = ClassVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)

        return visitor.classes
    }
}
