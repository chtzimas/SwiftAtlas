//
//  Analyzer.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/7/26.
//

import SwiftParser
import SwiftSyntax

public final class Analyzer {

    public init() {}

    public func analyze(source: String) -> SourceFileNode {
        let sourceFile = Parser.parse(source: source)

        let visitor = ClassVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)

        return SourceFileNode(
            classes: visitor.classes
        )
    }
}
