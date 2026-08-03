//
//  AnalyzerTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/7/26.
//

import Foundation
import SwiftAtlasCore
import Testing

struct AnalyzerTests {

    @Test
    func extractsClassesFromSource() {

        // Given
        let sut = sut
        let source = sourceFile
        let expectedClasses = classNodes

        // When
        let result = sut.analyze(source: source)

        // Then
        #expect(result.classes == expectedClasses)
    }

    @Test
    func extractsStructsFromSource() {

        // Given
        let sut = sut
        let source = sourceFile
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
        let source = sourceFile
        let expectedEnums = enumNodes

        // When
        let result = sut.analyze(source: source)

        // Then
        #expect(result.enums == expectedEnums)
    }

    @Test
    func extractsProtocolsFromSource() {

        // Given
        let sut = sut
        let source = sourceFile
        let expectedProtocols = protocolNodes

        // When
        let result = sut.analyze(source: source)

        // Then
        #expect(result.protocols == expectedProtocols)
    }
}

// MARK: - Factory

private extension AnalyzerTests {

    var sut: Analyzer {
        Analyzer()
    }

    var sourceFile: String {
        let url = Bundle.module.url(
            forResource: "Sample",
            withExtension: "txt"
        )!

        return try! String(contentsOf: url, encoding: .utf8)
    }

    var classNodes: [ClassNode] {
        [
            ClassNode(name: "User", inheritedTypes: ["Person", "Some"]),
            ClassNode(name: "Dog", inheritedTypes: ["Animal", "Some"])
        ]
    }

    var structNodes: [StructNode] {
        [
            StructNode(name: "Account", inheritedTypes: ["Codable", "Equatable"]),
            StructNode(name: "Point")
        ]
    }

    var enumNodes: [EnumNode] {
        [
            EnumNode(name: "Direction", inheritedTypes: ["String", "CaseIterable"]),
            EnumNode(name: "Suit")
        ]
    }

    var protocolNodes: [ProtocolNode] {
        [
            ProtocolNode(name: "Repository", inheritedTypes: ["Fetchable", "Storable"]),
            ProtocolNode(name: "Loggable")
        ]
    }
}
