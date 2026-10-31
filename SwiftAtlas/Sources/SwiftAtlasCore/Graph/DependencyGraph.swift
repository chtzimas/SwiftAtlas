//
//  DependencyGraph.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

/// A graph of strong, class-to-class stored-property references — the
/// relationships that can produce a retain cycle. A node is a class; an edge
/// from A to B means A holds a non-`weak`/`unowned` stored property whose
/// type resolves to class B.
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
                for classNode in sourceFile.classes {
                    let identity = TypeIdentity(module: module.name, name: classNode.name, kind: .class)
                    nodes.insert(identity)

                    let strongClassDependencies = classNode.properties.compactMap { property -> TypeIdentity? in
                        guard property.ownership == .strong,
                              case .resolved(let target) = property.type,
                              target.kind == .class else {
                            return nil
                        }
                        return target
                    }

                    guard !strongClassDependencies.isEmpty else { continue }
                    edges[identity, default: []].formUnion(strongClassDependencies)
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
