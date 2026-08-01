//
//  AnalyzerTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/7/26.
//

import Testing
import SwiftAtlasCore

struct AnalyzerTests {

    @Test
    func extractsClassesFromSource() {

        // Given
        let source = """
        class User: Person, Some {}
        class Dog: Animal, Some {}
        """
        let expectedResult = [
            ClassNode(name: "User", inheritedTypes: ["Person", "Some"]),
            ClassNode(name: "Dog", inheritedTypes: ["Animal", "Some"])
        ]
        let analyzer = Analyzer()

        // When
        let result = analyzer.analyze(source: source)

        // Then
        #expect(result == expectedResult)
    }
}
