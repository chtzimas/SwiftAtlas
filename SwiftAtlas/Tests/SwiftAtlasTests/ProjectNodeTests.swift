//
//  ProjectNodeTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 6/9/26.
//

import SwiftAtlasCore
import Testing

struct ProjectNodeTests {

    @Test
    func hasDeclarationsIsFalseWhenEmpty() {

        // Given
        let sut = ProjectNode(name: "Project")

        // Then
        #expect(sut.hasDeclarations == false)
    }

    @Test
    func hasDeclarationsIsFalseWhenModulesHaveNoDeclarations() {

        // Given
        let sut = ProjectNode(name: "Project", modules: [ModuleNode(name: "Feature")])

        // Then
        #expect(sut.hasDeclarations == false)
    }

    @Test
    func hasDeclarationsIsTrueWhenAnyModuleHasDeclarations() {

        // Given
        let sut = ProjectNode(
            name: "Project",
            modules: [
                ModuleNode(name: "Empty"),
                ModuleNode(name: "Feature", sourceFiles: [SourceFileNode(classes: [ClassNode(name: "User")])])
            ]
        )

        // Then
        #expect(sut.hasDeclarations == true)
    }
}
