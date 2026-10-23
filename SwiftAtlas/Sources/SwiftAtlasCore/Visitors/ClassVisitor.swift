//
//  ClassVisitor.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/7/26.
//

import SwiftSyntax

final class ClassVisitor: SyntaxVisitor {

    var classes: [ClassNode] = []

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let inheritedTypes = node.inheritanceClause?.inheritedTypeNames ?? []
        classes.append(
            ClassNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes.map(TypeReference.unresolved)
            )
        )

        return .visitChildren
    }
}
