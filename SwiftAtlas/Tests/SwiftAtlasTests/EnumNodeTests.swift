//
//  EnumNodeTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

import SwiftAtlasCore
import Testing

struct EnumNodeTests {

    @Test
    func hasInheritanceIsFalseWhenNoInheritedTypes() {

        // Given
        let sut = EnumNode(name: "Suit")

        // Then
        #expect(sut.hasInheritance == false)
    }

    @Test
    func hasInheritanceIsTrueWhenInheritedTypesArePresent() {

        // Given
        let sut = EnumNode(name: "Direction", inheritedTypes: [.unresolved("String")])

        // Then
        #expect(sut.hasInheritance == true)
    }
}
