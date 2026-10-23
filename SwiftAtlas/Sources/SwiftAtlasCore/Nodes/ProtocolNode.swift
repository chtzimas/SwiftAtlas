//
//  ProtocolNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 3/8/26.
//

public struct ProtocolNode: Equatable {
    public let name: String
    public let inheritedTypes: [TypeReference]

    public init(name: String, inheritedTypes: [TypeReference] = []) {
        self.name = name
        self.inheritedTypes = inheritedTypes
    }

    public var hasInheritance: Bool {
        !inheritedTypes.isEmpty
    }
}
