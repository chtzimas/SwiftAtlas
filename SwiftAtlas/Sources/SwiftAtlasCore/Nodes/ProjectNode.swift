//
//  ProjectNode.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 6/9/26.
//

public struct ProjectNode: Equatable {
    public let name: String
    public let modules: [ModuleNode]

    public init(name: String, modules: [ModuleNode] = []) {
        self.name = name
        self.modules = modules
    }

    public var hasDeclarations: Bool {
        modules.contains { $0.hasDeclarations }
    }
}
