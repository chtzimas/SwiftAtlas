//
//  EnumVisitor.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 3/8/26.
//

import SwiftSyntax

final class EnumVisitor: SyntaxVisitor {

    var enums: [EnumNode] = []

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let inheritedTypes = node.inheritanceClause?.inheritedTypeNames ?? []
        enums.append(
            EnumNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes
            )
        )

        return .visitChildren
    }
}
