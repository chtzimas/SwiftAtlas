//
//  ModuleNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

public struct ModuleNode: Equatable {
    public let name: String
    public let sourceFiles: [SourceFileNode]

    public init(name: String, sourceFiles: [SourceFileNode] = []) {
        self.name = name
        self.sourceFiles = sourceFiles
    }

    public var hasDeclarations: Bool {
        sourceFiles.contains { $0.hasDeclarations }
    }
}
