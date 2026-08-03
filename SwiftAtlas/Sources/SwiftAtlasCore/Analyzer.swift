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

        let classVisitor = ClassVisitor(viewMode: .sourceAccurate)
        classVisitor.walk(sourceFile)

        let structVisitor = StructVisitor(viewMode: .sourceAccurate)
        structVisitor.walk(sourceFile)

        let enumVisitor = EnumVisitor(viewMode: .sourceAccurate)
        enumVisitor.walk(sourceFile)

        return SourceFileNode(
            classes: classVisitor.classes,
            structs: structVisitor.structs,
            enums: enumVisitor.enums
        )
    }
}
