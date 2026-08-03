//
//  SourceFileNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/8/26.
//

public struct SourceFileNode: Equatable {
    public let classes: [ClassNode]
    public let structs: [StructNode]

    public init(
        classes: [ClassNode] = [],
        structs: [StructNode] = []
    ) {
        self.classes = classes
        self.structs = structs
    }
}
