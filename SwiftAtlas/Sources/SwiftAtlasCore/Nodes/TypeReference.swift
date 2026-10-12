//
//  TypeReference.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/10/26.
//

public enum TypeReference: Equatable {
    case unresolved(String)
    case resolved(TypeIdentity)
    case external(String)
    case ambiguous(String)

    public var name: String {
        switch self {
        case .unresolved(let name), .external(let name), .ambiguous(let name):
            return name
        case .resolved(let identity):
            return identity.name
        }
    }
}
