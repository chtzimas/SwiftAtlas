//
//  DependencyGraph.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

public struct DependencyGraph: Equatable {
    public let nodes: Set<TypeIdentity>
    public let edges: [TypeIdentity: Set<TypeIdentity>]

    public init(nodes: Set<TypeIdentity> = [], edges: [TypeIdentity: Set<TypeIdentity>] = [:]) {
        self.nodes = nodes
        self.edges = edges
    }

    public init(project: ProjectNode) {
        var nodes: Set<TypeIdentity> = []
        var edges: [TypeIdentity: Set<TypeIdentity>] = [:]

        for module in project.modules {
            for sourceFile in module.sourceFiles {
                for node in sourceFile.classes {
                    Self.addNode(module: module.name, name: node.name, kind: .class, inheritedTypes: node.inheritedTypes, nodes: &nodes, edges: &edges)
                }
                for node in sourceFile.structs {
                    Self.addNode(module: module.name, name: node.name, kind: .struct, inheritedTypes: node.inheritedTypes, nodes: &nodes, edges: &edges)
                }
                for node in sourceFile.enums {
                    Self.addNode(module: module.name, name: node.name, kind: .enum, inheritedTypes: node.inheritedTypes, nodes: &nodes, edges: &edges)
                }
                for node in sourceFile.protocols {
                    Self.addNode(module: module.name, name: node.name, kind: .protocol, inheritedTypes: node.inheritedTypes, nodes: &nodes, edges: &edges)
                }
            }
        }

        self.nodes = nodes
        self.edges = edges
    }

    public func dependencies(of identity: TypeIdentity) -> Set<TypeIdentity> {
        edges[identity] ?? []
    }
}

private extension DependencyGraph {

    static func addNode(
        module: String,
        name: String,
        kind: DeclarationKind,
        inheritedTypes: [TypeReference],
        nodes: inout Set<TypeIdentity>,
        edges: inout [TypeIdentity: Set<TypeIdentity>]
    ) {
        let identity = TypeIdentity(module: module, name: name, kind: kind)
        nodes.insert(identity)

        let resolvedDependencies = inheritedTypes.compactMap { reference -> TypeIdentity? in
            guard case .resolved(let target) = reference else { return nil }
            return target
        }

        guard !resolvedDependencies.isEmpty else { return }
        edges[identity, default: []].formUnion(resolvedDependencies)
    }
}
