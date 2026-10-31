//
//  PropertyExtractionTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

import SwiftAtlasCore
import Testing

struct PropertyExtractionTests {

    @Test
    func extractsStoredPropertiesWithTheirOwnershipAndType() {

        // Given
        let sut = sut
        let source = """
        class Owner {
            var strongChild: Child
            let letChild: Child
            weak var weakChild: Child?
            unowned var unownedChild: Child
            static var shared: Child
            var computed: Child { Child() }
            var explicitlyComputed: Child {
                get { Child() }
                set { }
            }
            var observed: Child {
                willSet { }
                didSet { }
            }
            var collection: [Child]
            var optionalChild: Child?
        }
        """

        // When
        let result = sut.analyze(source: source).classes.first?.properties

        // Then
        #expect(result == expectedProperties)
    }
}

private extension PropertyExtractionTests {

    var sut: Analyzer {
        Analyzer()
    }

    var expectedProperties: [PropertyNode] {
        [
            PropertyNode(name: "strongChild", type: .unresolved("Child"), ownership: .strong),
            PropertyNode(name: "letChild", type: .unresolved("Child"), ownership: .strong),
            PropertyNode(name: "weakChild", type: .unresolved("Child"), ownership: .weak),
            PropertyNode(name: "unownedChild", type: .unresolved("Child"), ownership: .unowned),
            PropertyNode(name: "observed", type: .unresolved("Child"), ownership: .strong),
            PropertyNode(name: "optionalChild", type: .unresolved("Child"), ownership: .strong)
        ]
    }
}
