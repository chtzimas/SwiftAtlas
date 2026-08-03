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
        let inheritedTypes = node.inheritanceClause?.inheritedTypes.compactMap {
            guard let identifier = $0.type.as(IdentifierTypeSyntax.self) else {
                return nil
            }

            return identifier.name.text
        } ?? [String]()
        protocols.append(
            ProtocolNode(
                name: node.name.text,
                inheritedTypes: inheritedTypes
            )
        )

        return .visitChildren
    }
}
