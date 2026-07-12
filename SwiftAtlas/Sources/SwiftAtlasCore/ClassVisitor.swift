//
//  ClassVisitor.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/7/26.
//

import SwiftSyntax

final class ClassVisitor: SyntaxVisitor {

    var classes: [String] = []

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        classes.append(node.name.text)

        return .visitChildren
    }
}
