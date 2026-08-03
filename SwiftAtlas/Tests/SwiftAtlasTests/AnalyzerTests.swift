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

    @Test
    func extractsStructsFromSource() {

        // Given
        let sut = sut
        let source = structSourceFile
        let expectedStructs = structNodes

        // When
        let result = sut.analyze(source: source)

        // Then
        #expect(result.structs == expectedStructs)
    }

    @Test
    func extractsEnumsFromSource() {

        // Given
        let sut = sut
        let source = enumSourceFile
        let expectedEnums = enumNodes

        // When
        let result = sut.analyze(source: source)

        // Then
        #expect(result.enums == expectedEnums)
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

    var structSourceFile: String {
        """
        struct User: Codable, Equatable {}
        struct Point {}
        """
    }

    var structNodes: [StructNode] {
        [
            StructNode(name: "User", inheritedTypes: ["Codable", "Equatable"]),
            StructNode(name: "Point")
        ]
    }

    var enumSourceFile: String {
        """
        enum Direction: String, CaseIterable {}
        enum Empty {}
        """
    }

    var enumNodes: [EnumNode] {
        [
            EnumNode(name: "Direction", inheritedTypes: ["String", "CaseIterable"]),
            EnumNode(name: "Empty")
        ]
    }
}
