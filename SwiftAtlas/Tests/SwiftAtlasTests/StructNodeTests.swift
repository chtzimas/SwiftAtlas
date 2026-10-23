//
//  StructNodeTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

import SwiftAtlasCore
import Testing

struct StructNodeTests {

    @Test
    func hasInheritanceIsFalseWhenNoInheritedTypes() {

        // Given
        let sut = StructNode(name: "Point")

        // Then
        #expect(sut.hasInheritance == false)
    }

    @Test
    func hasInheritanceIsTrueWhenInheritedTypesArePresent() {

        // Given
        let sut = StructNode(name: "Account", inheritedTypes: [.unresolved("Codable")])

        // Then
        #expect(sut.hasInheritance == true)
    }
}
