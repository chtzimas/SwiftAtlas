//
//  DependencyGraphTests.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

import SwiftAtlasCore
import Testing

struct DependencyGraphTests {

    @Test
    func includesEveryDeclarationAcrossModulesAsANode() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.nodes == [alphaIdentity, betaIdentity, gammaIdentity, sharedIdentity, deltaIdentity])
    }

    @Test
    func addsAnEdgeForAResolvedInheritedType() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: alphaIdentity) == [sharedIdentity])
    }

    @Test
    func addsAnEdgeAcrossModuleBoundaries() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: deltaIdentity) == [alphaIdentity])
    }

    @Test
    func ignoresUnresolvedExternalAndAmbiguousReferences() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: betaIdentity).isEmpty)
    }

    @Test
    func aDeclarationWithoutInheritanceHasNoDependencies() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: gammaIdentity).isEmpty)
    }

    @Test
    func dependenciesOfReturnsEmptySetForAnUnknownNode() {

        // Given
        let sut = DependencyGraph()
        let unknown = TypeIdentity(module: "FeatureA", name: "Unknown", kind: .class)

        // Then
        #expect(sut.dependencies(of: unknown).isEmpty)
    }
}

private extension DependencyGraphTests {

    var project: ProjectNode {
        ProjectNode(
            name: "Fixture",
            modules: [
                ModuleNode(
                    name: "FeatureA",
                    sourceFiles: [
                        SourceFileNode(
                            name: "TypeA.swift",
                            classes: [ClassNode(name: "Alpha", inheritedTypes: [.resolved(sharedIdentity)])],
                            structs: [
                                StructNode(
                                    name: "Beta",
                                    inheritedTypes: [.unresolved("Pending"), .external("Codable"), .ambiguous("Thing")]
                                )
                            ],
                            enums: [EnumNode(name: "Gamma")],
                            protocols: [ProtocolNode(name: "Shared")]
                        )
                    ]
                ),
                ModuleNode(
                    name: "FeatureB",
                    sourceFiles: [
                        SourceFileNode(
                            name: "TypeB.swift",
                            classes: [ClassNode(name: "Delta", inheritedTypes: [.resolved(alphaIdentity)])]
                        )
                    ]
                )
            ]
        )
    }

    var alphaIdentity: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Alpha", kind: .class) }
    var betaIdentity: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Beta", kind: .struct) }
    var gammaIdentity: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Gamma", kind: .enum) }
    var sharedIdentity: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Shared", kind: .protocol) }
    var deltaIdentity: TypeIdentity { TypeIdentity(module: "FeatureB", name: "Delta", kind: .class) }
}
