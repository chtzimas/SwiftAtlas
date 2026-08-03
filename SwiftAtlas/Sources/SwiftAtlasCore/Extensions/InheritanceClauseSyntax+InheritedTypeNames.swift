//
//  InheritanceClauseSyntax+InheritedTypeNames.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 3/8/26.
//

import SwiftSyntax

extension InheritanceClauseSyntax {
    var inheritedTypeNames: [String] {
        inheritedTypes.compactMap {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text
        }
    }
}
