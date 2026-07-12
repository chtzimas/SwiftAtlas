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

    public func analyze(source: String) -> [ClassNode] {
        let sourceFile = Parser.parse(source: source)

        let visitor = ClassVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)

        let classNodes = visitor.classes.map { ClassNode(name: $0) }
        return classNodes
    }
}
