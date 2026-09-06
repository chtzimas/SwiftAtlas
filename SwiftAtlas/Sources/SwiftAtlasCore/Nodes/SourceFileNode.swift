//
//  SourceFileNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/8/26.
//

public struct SourceFileNode: Equatable {
    public let name: String
    public let classes: [ClassNode]
    public let structs: [StructNode]
    public let enums: [EnumNode]
    public let protocols: [ProtocolNode]

    public init(
        name: String = "",
        classes: [ClassNode] = [],
        structs: [StructNode] = [],
        enums: [EnumNode] = [],
        protocols: [ProtocolNode] = []
    ) {
        self.name = name
        self.classes = classes
        self.structs = structs
        self.enums = enums
        self.protocols = protocols
    }

    public var hasDeclarations: Bool {
        !classes.isEmpty || !structs.isEmpty || !enums.isEmpty || !protocols.isEmpty
    }

    public func renamed(to name: String) -> SourceFileNode {
        SourceFileNode(name: name, classes: classes, structs: structs, enums: enums, protocols: protocols)
    }
}
