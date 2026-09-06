//
//  ModuleNodeTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

import SwiftAtlasCore
import Testing

struct ModuleNodeTests {

    @Test
    func hasDeclarationsIsFalseWhenEmpty() {

        // Given
        let sut = ModuleNode(name: "Feature")

        // Then
        #expect(sut.hasDeclarations == false)
    }

    @Test
    func hasDeclarationsIsFalseWhenSourceFilesHaveNoDeclarations() {

        // Given
        let sut = ModuleNode(name: "Feature", sourceFiles: [SourceFileNode()])

        // Then
        #expect(sut.hasDeclarations == false)
    }

    @Test
    func hasDeclarationsIsTrueWhenAnySourceFileHasDeclarations() {

        // Given
        let sut = ModuleNode(
            name: "Feature",
            sourceFiles: [
                SourceFileNode(),
                SourceFileNode(classes: [ClassNode(name: "User")])
            ]
        )

        // Then
        #expect(sut.hasDeclarations == true)
    }
}
