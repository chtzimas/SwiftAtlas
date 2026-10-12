//
//  ProtocolVisitor.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 3/8/26.
//

import SwiftSyntax

final class ProtocolVisitor: SyntaxVisitor {

    var protocols: [ProtocolNode] = []

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        let inheritedTypes = node.inheritanceClause?.inheritedTypeNames ?? []
        protocols.append(
            ProtocolNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes.map(TypeReference.unresolved)
            )
        )

        return .visitChildren
    }
}
