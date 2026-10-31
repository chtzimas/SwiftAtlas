//
//  Cycle.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

/// A dependency cycle: an ordered, non-repeating sequence of types where each
/// type depends on the next, and the last depends back on the first.
public struct Cycle: Hashable {
    public let path: [TypeIdentity]

    public init(path: [TypeIdentity]) {
        self.path = path
    }
}
