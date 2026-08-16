//
//  ProtocolNodeTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

import SwiftAtlasCore
import Testing

struct ProtocolNodeTests {

    @Test
    func hasInheritanceIsFalseWhenNoInheritedTypes() {

        // Given
        let sut = ProtocolNode(name: "Loggable")

        // Then
        #expect(sut.hasInheritance == false)
    }

    @Test
    func hasInheritanceIsTrueWhenInheritedTypesArePresent() {

        // Given
        let sut = ProtocolNode(name: "Repository", inheritedTypes: ["Fetchable"])

        // Then
        #expect(sut.hasInheritance == true)
    }
}
