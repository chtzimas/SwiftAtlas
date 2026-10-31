//
//  TypeResolver.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 11/10/26.
//

struct TypeResolver {

    func resolve(_ project: ProjectNode) -> ProjectNode {
        let index = buildIndex(for: project)

        return ProjectNode(
            name: project.name,
            modules: project.modules.map { resolve($0, using: index) }
        )
    }
}

private extension TypeResolver {

    struct DeclarationEntry {
        let module: String
        let kind: DeclarationKind
    }

    typealias Index = [String: [DeclarationEntry]]

    func buildIndex(for project: ProjectNode) -> Index {
        var index: Index = [:]

        for module in project.modules {
            for sourceFile in module.sourceFiles {
                for node in sourceFile.classes {
                    index[node.name, default: []].append(DeclarationEntry(module: module.name, kind: .class))
                }
                for node in sourceFile.structs {
                    index[node.name, default: []].append(DeclarationEntry(module: module.name, kind: .struct))
                }
                for node in sourceFile.enums {
                    index[node.name, default: []].append(DeclarationEntry(module: module.name, kind: .enum))
                }
                for node in sourceFile.protocols {
                    index[node.name, default: []].append(DeclarationEntry(module: module.name, kind: .protocol))
                }
            }
        }

        return index
    }

    func resolve(_ module: ModuleNode, using index: Index) -> ModuleNode {
        ModuleNode(
            name: module.name,
            sourceFiles: module.sourceFiles.map { resolve($0, using: index) }
        )
    }

    func resolve(_ sourceFile: SourceFileNode, using index: Index) -> SourceFileNode {
        SourceFileNode(
            name: sourceFile.name,
            classes: sourceFile.classes.map { resolve($0, using: index) },
            structs: sourceFile.structs.map { resolve($0, using: index) },
            enums: sourceFile.enums.map { resolve($0, using: index) },
            protocols: sourceFile.protocols.map { resolve($0, using: index) }
        )
    }

    func resolve(_ node: ClassNode, using index: Index) -> ClassNode {
        ClassNode(
            name: node.name,
            inheritedTypes: node.inheritedTypes.map { resolve($0, using: index) },
            properties: node.properties.map { resolve($0, using: index) }
        )
    }

    func resolve(_ property: PropertyNode, using index: Index) -> PropertyNode {
        PropertyNode(name: property.name, type: resolve(property.type, using: index), ownership: property.ownership)
    }

    func resolve(_ node: StructNode, using index: Index) -> StructNode {
        StructNode(name: node.name, inheritedTypes: node.inheritedTypes.map { resolve($0, using: index) })
    }

    func resolve(_ node: EnumNode, using index: Index) -> EnumNode {
        EnumNode(name: node.name, inheritedTypes: node.inheritedTypes.map { resolve($0, using: index) })
    }

    func resolve(_ node: ProtocolNode, using index: Index) -> ProtocolNode {
        ProtocolNode(name: node.name, inheritedTypes: node.inheritedTypes.map { resolve($0, using: index) })
    }

    func resolve(_ reference: TypeReference, using index: Index) -> TypeReference {
        guard case .unresolved(let name) = reference else { return reference }

        let matches = index[name] ?? []
        switch matches.count {
        case 0:
            return .external(name)
        case 1:
            let match = matches[0]
            return .resolved(TypeIdentity(module: match.module, name: name, kind: match.kind))
        default:
            return .ambiguous(name)
        }
    }
}
