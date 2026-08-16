//
//  ClassNodeTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

import SwiftAtlasCore
import Testing

struct ClassNodeTests {

    @Test
    func hasInheritanceIsFalseWhenNoInheritedTypes() {

        // Given
        let sut = ClassNode(name: "User")

        // Then
        #expect(sut.hasInheritance == false)
    }

    @Test
    func hasInheritanceIsTrueWhenInheritedTypesArePresent() {

        // Given
        let sut = ClassNode(name: "User", inheritedTypes: ["Person"])

        // Then
        #expect(sut.hasInheritance == true)
    }
}
