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

    public init(
        classes: [ClassNode] = [],
        structs: [StructNode] = [],
        enums: [EnumNode] = []
    ) {
        self.classes = classes
        self.structs = structs
        self.enums = enums
    }
}
