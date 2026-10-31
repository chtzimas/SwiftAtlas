//
//  DependencyGraph.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

/// A graph of strong-reference relationships that can produce a retain
/// cycle. A node is a class or a protocol conformed to by at least one
/// analyzed class. An edge from A to B means either: A holds a non-`weak`/
/// `unowned` stored property whose type resolves to B (a class, or a
/// protocol — the latter covers the idiomatic delegate pattern, since
/// any conforming class could be assigned there); or B is a class that
/// conforms to protocol A, which is how such a property can end up
/// strongly holding B in practice. Only conformances actually observed on
/// a parsed `ClassNode` produce an edge, so a protocol a struct happens to
/// also satisfy never introduces a false reference — there's no edge to
/// anything but the classes it's genuinely implemented by.
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

                    let strongDependencies = classNode.properties.compactMap { property -> TypeIdentity? in
                        guard property.ownership == .strong,
                              case .resolved(let target) = property.type,
                              target.kind == .class || target.kind == .protocol else {
                            return nil
                        }
                        return target
                    }

                    if !strongDependencies.isEmpty {
                        edges[identity, default: []].formUnion(strongDependencies)
                    }

                    let conformedProtocols = classNode.inheritedTypes.compactMap { reference -> TypeIdentity? in
                        guard case .resolved(let target) = reference, target.kind == .protocol else {
                            return nil
                        }
                        return target
                    }

                    for protocolIdentity in conformedProtocols {
                        nodes.insert(protocolIdentity)
                        edges[protocolIdentity, default: []].insert(identity)
                    }
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
