//
//  TypeIdentity.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/10/26.
//

public struct TypeIdentity: Hashable {
    public let module: String
    public let name: String
    public let kind: DeclarationKind

    public init(module: String, name: String, kind: DeclarationKind) {
        self.module = module
        self.name = name
        self.kind = kind
    }
}
