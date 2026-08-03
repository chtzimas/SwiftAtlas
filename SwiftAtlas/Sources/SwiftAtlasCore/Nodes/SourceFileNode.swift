//
//  SourceFileNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/8/26.
//

public struct SourceFileNode: Equatable {
    public let classes: [ClassNode]
    public let structs: [StructNode]
    public let enums: [EnumNode]
    public let protocols: [ProtocolNode]

    public init(
        classes: [ClassNode] = [],
        structs: [StructNode] = [],
        enums: [EnumNode] = [],
        protocols: [ProtocolNode] = []
    ) {
        self.classes = classes
        self.structs = structs
        self.enums = enums
        self.protocols = protocols
    }
}
