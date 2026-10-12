//
//  ClassNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 12/7/26.
//

public struct ClassNode: Equatable {
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
