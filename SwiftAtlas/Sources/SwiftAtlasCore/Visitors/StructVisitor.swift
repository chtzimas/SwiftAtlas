//
//  StructVisitor.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 3/8/26.
//

import SwiftSyntax

final class StructVisitor: SyntaxVisitor {

    var structs: [StructNode] = []

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let inheritedTypes = node.inheritanceClause?.inheritedTypeNames ?? []
        structs.append(
            StructNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes
            )
        )

        return .visitChildren
    }
}
