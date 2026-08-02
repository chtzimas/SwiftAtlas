//
//  SourceFileNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/8/26.
//

public struct SourceFileNode: Equatable {
    public let classes: [ClassNode]

    public init(classes: [ClassNode]) {
        self.classes = classes
    }
}
