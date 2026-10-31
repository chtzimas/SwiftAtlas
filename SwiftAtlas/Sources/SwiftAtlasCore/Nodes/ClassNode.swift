//
//  ClassNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 12/7/26.
//

public struct ClassNode: Equatable {
    public let name: String
    public let inheritedTypes: [TypeReference]
    public let properties: [PropertyNode]

    public init(name: String, inheritedTypes: [TypeReference] = [], properties: [PropertyNode] = []) {
        self.name = name
        self.inheritedTypes = inheritedTypes
        self.properties = properties
    }
    
    public var hasInheritance: Bool {
        !inheritedTypes.isEmpty
    }
}
