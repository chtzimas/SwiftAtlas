//
//  CycleDetector.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

public struct CycleDetector {

    public init() {}

    public func detectCycles(in graph: DependencyGraph) -> [Cycle] {
        var state: [TypeIdentity: VisitState] = [:]
        var stack: [TypeIdentity] = []
        var cycles: [Cycle] = []
        var seenCycles: Set<Cycle> = []

        for node in graph.nodes.sorted(by: Self.isOrderedBefore) where state[node] != .visited {
            visit(node, in: graph, state: &state, stack: &stack, cycles: &cycles, seenCycles: &seenCycles)
        }

        return cycles
    }

    /// Cycles present in `head` but not already present in `base` — the set
    /// a PR check should actually fail on, since a pre-existing cycle isn't
    /// something the current change introduced.
    public func detectNewCycles(in head: DependencyGraph, comparedTo base: DependencyGraph) -> [Cycle] {
        let baseCycles = Set(detectCycles(in: base))
        return detectCycles(in: head).filter { !baseCycles.contains($0) }
    }
}

private extension CycleDetector {

    enum VisitState {
        case visiting
        case visited
    }

    func visit(
        _ node: TypeIdentity,
        in graph: DependencyGraph,
        state: inout [TypeIdentity: VisitState],
        stack: inout [TypeIdentity],
        cycles: inout [Cycle],
        seenCycles: inout Set<Cycle>
    ) {
        state[node] = .visiting
        stack.append(node)

        for dependency in graph.dependencies(of: node).sorted(by: Self.isOrderedBefore) {
            if state[dependency] == .visiting {
                if let startIndex = stack.firstIndex(of: dependency) {
                    let cycle = Cycle(path: Self.normalized(Array(stack[startIndex...])))
                    if seenCycles.insert(cycle).inserted {
                        cycles.append(cycle)
                    }
                }
            } else if state[dependency] != .visited {
                visit(dependency, in: graph, state: &state, stack: &stack, cycles: &cycles, seenCycles: &seenCycles)
            }
        }

        stack.removeLast()
        state[node] = .visited
    }

    /// Rotates a cycle's path so it starts at its lowest-sorted node, giving each
    /// cycle a single canonical representation regardless of where it was discovered.
    static func normalized(_ path: [TypeIdentity]) -> [TypeIdentity] {
        guard let startIndex = path.indices.min(by: { isOrderedBefore(path[$0], path[$1]) }) else {
            return path
        }
        return Array(path[startIndex...] + path[..<startIndex])
    }

    static func isOrderedBefore(_ lhs: TypeIdentity, _ rhs: TypeIdentity) -> Bool {
        (lhs.module, lhs.name) < (rhs.module, rhs.name)
    }
}
