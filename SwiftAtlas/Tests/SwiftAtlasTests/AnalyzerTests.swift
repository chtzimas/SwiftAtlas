//
//  AnalyzerTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/7/26.
//

import Testing
import SwiftAtlasCore

struct AnalyzerTests {

    @Test
    func extractsClassesFromSource() {

        // Given
        let source = """
        class User {}
        class Product {}
        """
        let analyzer = Analyzer()

        // When
        let result = analyzer.analyze(source: source)

        // Then
        #expect(result == ["User", "Product"])
    }
}
