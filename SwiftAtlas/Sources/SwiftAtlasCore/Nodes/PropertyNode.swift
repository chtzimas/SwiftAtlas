//
//  PropertyNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

/// A stored property declared directly in a class body.
public struct PropertyNode: Equatable {
    public let name: String
    public let type: TypeReference
    public let ownership: Ownership

    public init(name: String, type: TypeReference, ownership: Ownership = .strong) {
        self.name = name
        self.type = type
        self.ownership = ownership
    }

    public enum Ownership: Equatable {
        case strong
        case weak
        case unowned
    }
}
