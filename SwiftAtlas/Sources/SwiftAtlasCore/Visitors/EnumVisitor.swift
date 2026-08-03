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
        let inheritedTypes = node.inheritanceClause?.inheritedTypes.compactMap {
            guard let identifier = $0.type.as(IdentifierTypeSyntax.self) else {
                return nil
            }

            return identifier.name.text
        } ?? [String]()
        enums.append(
            EnumNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes
            )
        )

        return .visitChildren
    }
}
