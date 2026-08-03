//
//  ClassNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 12/7/26.
//

public struct ClassNode: Equatable {
    public let name: String
    public let inheritedTypes: [String]

    public init(name: String, inheritedTypes: [String] = []) {
        self.name = name
        self.inheritedTypes = inheritedTypes
    }
    
    public var hasInheritance: Bool {
        !inheritedTypes.isEmpty
    }
}
