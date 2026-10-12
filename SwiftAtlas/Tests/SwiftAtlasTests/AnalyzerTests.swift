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

    @Test
    func analyzesAllSwiftFilesInDirectory() throws {

        // Given
        let sut = sut
        let directory = fixtureDirectory
        let expectedSourceFiles = directorySourceFiles

        // When
        let result = try sut.analyze(directory: directory)

        // Then
        #expect(result == expectedSourceFiles)
    }

    @Test
    func analyzesProjectStructureInPackage() throws {

        // Given
        let sut = sut
        let directory = fixturePackageDirectory
        let expectedProject = fixtureProject

        // When
        let result = try sut.analyze(package: directory)

        // Then
        #expect(result == expectedProject)
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

    var fixtureDirectory: URL {
        Bundle.module.resourceURL!.appendingPathComponent("Directory")
    }

    var directorySourceFiles: [SourceFileNode] {
        [
            SourceFileNode(name: "First.swift", classes: [ClassNode(name: "First", inheritedTypes: [.unresolved("Base")])]),
            SourceFileNode(name: "Second.swift", structs: [StructNode(name: "Second")])
        ]
    }

    var fixturePackageDirectory: URL {
        Bundle.module.resourceURL!.appendingPathComponent("Package")
    }

    var fixtureProject: ProjectNode {
        ProjectNode(
            name: "Fixture",
            modules: [
                ModuleNode(
                    name: "FeatureA",
                    sourceFiles: [
                        SourceFileNode(
                            name: "TypeA.swift",
                            classes: [
                                ClassNode(name: "Alpha", inheritedTypes: [.external("Base")]),
                                ClassNode(
                                    name: "Gamma",
                                    inheritedTypes: [.resolved(TypeIdentity(module: "FeatureA", name: "Alpha", kind: .class))]
                                )
                            ],
                            structs: [StructNode(name: "Epsilon", inheritedTypes: [.ambiguous("Shared")])],
                            protocols: [ProtocolNode(name: "Shared")]
                        )
                    ]
                ),
                ModuleNode(
                    name: "FeatureB",
                    sourceFiles: [
                        SourceFileNode(
                            name: "TypeB.swift",
                            classes: [
                                ClassNode(
                                    name: "Delta",
                                    inheritedTypes: [.resolved(TypeIdentity(module: "FeatureA", name: "Alpha", kind: .class))]
                                )
                            ],
                            structs: [StructNode(name: "Beta")],
                            protocols: [ProtocolNode(name: "Shared")]
                        )
                    ]
                )
            ]
        )
    }

    var classNodes: [ClassNode] {
        [
            ClassNode(name: "User", inheritedTypes: [.unresolved("Person"), .unresolved("Some")]),
            ClassNode(name: "Dog", inheritedTypes: [.unresolved("Animal"), .unresolved("Some")])
        ]
    }

    var structNodes: [StructNode] {
        [
            StructNode(name: "Account", inheritedTypes: [.unresolved("Codable"), .unresolved("Equatable")]),
            StructNode(name: "Point")
        ]
    }

    var enumNodes: [EnumNode] {
        [
            EnumNode(name: "Direction", inheritedTypes: [.unresolved("String"), .unresolved("CaseIterable")]),
            EnumNode(name: "Suit")
        ]
    }

    var protocolNodes: [ProtocolNode] {
        [
            ProtocolNode(name: "Repository", inheritedTypes: [.unresolved("Fetchable"), .unresolved("Storable")]),
            ProtocolNode(name: "Loggable")
        ]
    }
}
