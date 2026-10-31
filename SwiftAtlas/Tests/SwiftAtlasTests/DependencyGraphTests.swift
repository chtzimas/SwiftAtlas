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

    @Test
    func addsAnEdgeForAStrongPropertyResolvedToAProtocol() {

        // Given: Delegate declares no AnyObject constraint at all
        let delegateProtocol = TypeIdentity(module: "FeatureA", name: "Delegate", kind: .protocol)
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
                                        PropertyNode(name: "delegate", type: .resolved(delegateProtocol), ownership: .strong)
                                    ]
                                )
                            ],
                            protocols: [ProtocolNode(name: "Delegate")]
                        )
                    ]
                )
            ]
        )
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.dependencies(of: TypeIdentity(module: "FeatureA", name: "Owner", kind: .class)) == [delegateProtocol])
    }

    @Test
    func aProtocolWithNoConformingClassHasNoFurtherDependencies() {

        // Given: Owner strongly references Plain, but nothing in the project conforms to it
        let plainProtocol = TypeIdentity(module: "FeatureA", name: "Plain", kind: .protocol)
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
                                        PropertyNode(name: "value", type: .resolved(plainProtocol), ownership: .strong)
                                    ]
                                )
                            ],
                            protocols: [ProtocolNode(name: "Plain")]
                        )
                    ]
                )
            ]
        )
        let sut = DependencyGraph(project: project)

        // Then: the protocol node is a dead end, so it can't complete a cycle
        #expect(sut.dependencies(of: plainProtocol).isEmpty)
    }

    @Test
    func addsAConformanceEdgeFromAProtocolToEachConformingClass() {

        // Given: Delegate declares no AnyObject constraint at all
        let delegateProtocol = TypeIdentity(module: "FeatureA", name: "Delegate", kind: .protocol)
        let conformerIdentity = TypeIdentity(module: "FeatureA", name: "Conformer", kind: .class)
        let project = ProjectNode(
            name: "Fixture",
            modules: [
                ModuleNode(
                    name: "FeatureA",
                    sourceFiles: [
                        SourceFileNode(
                            classes: [
                                ClassNode(name: "Conformer", inheritedTypes: [.resolved(delegateProtocol)])
                            ],
                            protocols: [ProtocolNode(name: "Delegate")]
                        )
                    ]
                )
            ]
        )
        let sut = DependencyGraph(project: project)

        // Then
        #expect(sut.nodes.contains(delegateProtocol))
        #expect(sut.dependencies(of: delegateProtocol) == [conformerIdentity])
    }

    @Test
    func detectsAThreeHopRetainCycleThroughAProtocolTypedProperty() {

        // Given: ViewModel -(strong)-> Delegate -(conformed by)-> ViewController -(strong)-> ViewModel,
        // where Delegate declares no AnyObject constraint — conformance alone is enough.
        let sut = CycleDetector()
        let graph = DependencyGraph(project: delegatePatternProject(delegateOwnership: .strong))

        // When
        let result = sut.detectCycles(in: graph)

        // Then
        #expect(result == [
            Cycle(path: [
                TypeIdentity(module: "FeatureA", name: "Delegate", kind: .protocol),
                TypeIdentity(module: "FeatureA", name: "ViewController", kind: .class),
                TypeIdentity(module: "FeatureA", name: "ViewModel", kind: .class)
            ])
        ])
    }

    @Test
    func doesNotDetectACycleWhenTheProtocolTypedPropertyIsWeak() {

        // Given: the same shape, but ViewModel.delegate is weak
        let sut = CycleDetector()
        let graph = DependencyGraph(project: delegatePatternProject(delegateOwnership: .weak))

        // When
        let result = sut.detectCycles(in: graph)

        // Then
        #expect(result.isEmpty)
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

    func delegatePatternProject(delegateOwnership: PropertyNode.Ownership) -> ProjectNode {
        let delegateProtocol = TypeIdentity(module: "FeatureA", name: "Delegate", kind: .protocol)
        let viewModelIdentity = TypeIdentity(module: "FeatureA", name: "ViewModel", kind: .class)

        return ProjectNode(
            name: "Fixture",
            modules: [
                ModuleNode(
                    name: "FeatureA",
                    sourceFiles: [
                        SourceFileNode(
                            classes: [
                                ClassNode(
                                    name: "ViewModel",
                                    properties: [
                                        PropertyNode(name: "delegate", type: .resolved(delegateProtocol), ownership: delegateOwnership)
                                    ]
                                ),
                                ClassNode(
                                    name: "ViewController",
                                    inheritedTypes: [.resolved(delegateProtocol)],
                                    properties: [
                                        PropertyNode(name: "viewModel", type: .resolved(viewModelIdentity), ownership: .strong)
                                    ]
                                )
                            ],
                            protocols: [ProtocolNode(name: "Delegate")]
                        )
                    ]
                )
            ]
        )
    }
}
