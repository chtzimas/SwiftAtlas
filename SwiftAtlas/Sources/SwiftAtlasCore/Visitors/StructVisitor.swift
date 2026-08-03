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
        let inheritedTypes = node.inheritanceClause?.inheritedTypes.compactMap {
            guard let identifier = $0.type.as(IdentifierTypeSyntax.self) else {
                return nil
            }

            return identifier.name.text
        } ?? [String]()
        structs.append(
            StructNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes
            )
        )

        return .visitChildren
    }
}
