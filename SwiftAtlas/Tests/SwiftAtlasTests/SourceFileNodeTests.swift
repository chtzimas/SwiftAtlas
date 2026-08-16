//
//  SourceFileNodeTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

import SwiftAtlasCore
import Testing

struct SourceFileNodeTests {

    @Test
    func hasDeclarationsIsFalseWhenEmpty() {

        // Given
        let sut = SourceFileNode()

        // Then
        #expect(sut.hasDeclarations == false)
    }

    @Test
    func hasDeclarationsIsTrueWhenClassesArePresent() {

        // Given
        let sut = SourceFileNode(classes: [ClassNode(name: "User")])

        // Then
        #expect(sut.hasDeclarations == true)
    }

    @Test
    func hasDeclarationsIsTrueWhenStructsArePresent() {

        // Given
        let sut = SourceFileNode(structs: [StructNode(name: "Point")])

        // Then
        #expect(sut.hasDeclarations == true)
    }

    @Test
    func hasDeclarationsIsTrueWhenEnumsArePresent() {

        // Given
        let sut = SourceFileNode(enums: [EnumNode(name: "Direction")])

        // Then
        #expect(sut.hasDeclarations == true)
    }

    @Test
    func hasDeclarationsIsTrueWhenProtocolsArePresent() {

        // Given
        let sut = SourceFileNode(protocols: [ProtocolNode(name: "Loggable")])

        // Then
        #expect(sut.hasDeclarations == true)
    }
}
