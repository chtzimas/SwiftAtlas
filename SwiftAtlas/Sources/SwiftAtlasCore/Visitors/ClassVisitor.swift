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
        let properties = node.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .flatMap(\.storedPropertyNodes)

        classes.append(
            ClassNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes.map(TypeReference.unresolved),
                properties: properties
            )
        )

        return .visitChildren
    }
}
