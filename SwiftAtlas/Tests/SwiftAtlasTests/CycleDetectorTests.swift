//
//  CycleDetectorTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

import SwiftAtlasCore
import Testing

struct CycleDetectorTests {

    @Test
    func detectsNoCyclesInAnAcyclicGraph() {

        // Given
        let sut = CycleDetector()
        let graph = DependencyGraph(nodes: [alpha, beta], edges: [alpha: [beta]])

        // When
        let result = sut.detectCycles(in: graph)

        // Then
        #expect(result.isEmpty)
    }

    @Test
    func detectsADirectTwoNodeCycle() {

        // Given
        let sut = CycleDetector()
        let graph = DependencyGraph(nodes: [alpha, beta], edges: [alpha: [beta], beta: [alpha]])

        // When
        let result = sut.detectCycles(in: graph)

        // Then
        #expect(result == [Cycle(path: [alpha, beta])])
    }

    @Test
    func detectsALongerCycle() {

        // Given
        let sut = CycleDetector()
        let graph = DependencyGraph(
            nodes: [alpha, beta, gamma],
            edges: [alpha: [beta], beta: [gamma], gamma: [alpha]]
        )

        // When
        let result = sut.detectCycles(in: graph)

        // Then
        #expect(result == [Cycle(path: [alpha, beta, gamma])])
    }

    @Test
    func reportsEachDistinctCycleOnce() {

        // Given: two independent two-node cycles
        let sut = CycleDetector()
        let graph = DependencyGraph(
            nodes: [alpha, beta, gamma, delta],
            edges: [
                alpha: [beta],
                beta: [alpha],
                gamma: [delta],
                delta: [gamma]
            ]
        )

        // When
        let result = sut.detectCycles(in: graph)

        // Then
        #expect(result == [Cycle(path: [alpha, beta]), Cycle(path: [delta, gamma])])
    }

    @Test
    func ignoresNodesWithoutDependencies() {

        // Given
        let sut = CycleDetector()
        let graph = DependencyGraph(nodes: [alpha, beta], edges: [:])

        // When
        let result = sut.detectCycles(in: graph)

        // Then
        #expect(result.isEmpty)
    }
}

private extension CycleDetectorTests {

    var alpha: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Alpha", kind: .class) }
    var beta: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Beta", kind: .class) }
    var gamma: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Gamma", kind: .class) }
    var delta: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Delta", kind: .class) }
}
