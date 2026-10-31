//
//  Cycle.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

/// A potential retain cycle: an ordered, non-repeating sequence of classes
/// where each class strongly references the next, and the last strongly
/// references back to the first.
public struct Cycle: Hashable {
    public let path: [TypeIdentity]

    public init(path: [TypeIdentity]) {
        self.path = path
    }
}
