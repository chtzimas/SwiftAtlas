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
    func includesEveryClassAcrossModulesAsANode() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.nodes == [ownerIdentity, childIdentity, otherOwnerIdentity])
    }

    @Test
    func addsAnEdgeForAStrongPropertyResolvedToAClass() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: ownerIdentity) == [childIdentity])
    }

    @Test
    func addsAnEdgeAcrossModuleBoundaries() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: otherOwnerIdentity) == [childIdentity])
    }

    @Test
    func doesNotAddAnEdgeForAWeakProperty() {

        // Given
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: childIdentity).isEmpty)
    }

    @Test
    func doesNotAddAnEdgeWhenTheResolvedTargetIsNotAClass() {

        // Given: a strong property whose type resolves to a struct, not a class
        let project = ProjectNode(
            name: "Fixture",
            modules: [
                ModuleNode(
                    name: "FeatureA",
                    sourceFiles: [
                        SourceFileNode(
                            classes: [
                                ClassNode(
                                    name: "Owner",
                                    properties: [
                                        PropertyNode(
                                            name: "value",
                                            type: .resolved(TypeIdentity(module: "FeatureA", name: "Value", kind: .struct)),
                                            ownership: .strong
                                        )
                                    ]
                                )
                            ],
                            structs: [StructNode(name: "Value")]
                        )
                    ]
                )
            ]
        )
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: ownerIdentity).isEmpty)
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
                            classes: [
                                ClassNode(
                                    name: "Owner",
                                    properties: [
                                        PropertyNode(name: "child", type: .resolved(childIdentity), ownership: .strong)
                                    ]
                                ),
                                ClassNode(
                                    name: "Child",
                                    properties: [
                                        PropertyNode(name: "owner", type: .resolved(ownerIdentity), ownership: .weak)
                                    ]
                                )
                            ]
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
                                    name: "OtherOwner",
                                    properties: [
                                        PropertyNode(name: "child", type: .resolved(childIdentity), ownership: .strong)
                                    ]
                                )
                            ]
                        )
                    ]
                )
            ]
        )
    }

    var ownerIdentity: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Owner", kind: .class) }
    var childIdentity: TypeIdentity { TypeIdentity(module: "FeatureA", name: "Child", kind: .class) }
    var otherOwnerIdentity: TypeIdentity { TypeIdentity(module: "FeatureB", name: "OtherOwner", kind: .class) }
}
