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
        let inheritedTypes = node.inheritanceClause?.inheritedTypes.compactMap {
            guard let identifier = $0.type.as(IdentifierTypeSyntax.self) else {
                return nil
            }

            return identifier.name.text
        } ?? [String]()
        classes.append(
            ClassNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes
            )
        )

        return .visitChildren
    }
}
