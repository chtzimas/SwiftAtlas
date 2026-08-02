//
//  AnalyzerTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/7/26.
//

import SwiftAtlasCore
import Testing

struct AnalyzerTests {

    @Test
    func extractsClassesFromSource() {

        // Given
        let sut = sut
        let source = sourceFile
        let expectedResult = sourceFileNode

        // When
        let result = sut.analyze(source: source)

        // Then
        #expect(result == expectedResult)
    }
}

// MARK: - Factory

private extension AnalyzerTests {
    
    var sut: Analyzer {
        Analyzer()
    }
    
    var sourceFile: String {
        """
        class User: Person, Some {}
        class Dog: Animal, Some {}
        """
    }
    
    var sourceFileNode: SourceFileNode {
        SourceFileNode(
            classes: [
                ClassNode(name: "User", inheritedTypes: ["Person", "Some"]),
                ClassNode(name: "Dog", inheritedTypes: ["Animal", "Some"])
            ]
        )
    }
}
