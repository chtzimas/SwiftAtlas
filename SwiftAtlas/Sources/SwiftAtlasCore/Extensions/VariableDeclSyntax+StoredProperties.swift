//
//  VariableDeclSyntax+StoredProperties.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 31/10/26.
//

import SwiftSyntax

extension VariableDeclSyntax {
    /// The stored instance properties declared by this variable declaration,
    /// skipping computed properties, `static`/`class` properties, and any
    /// binding whose type isn't a simple (non-generic) name.
    var storedPropertyNodes: [PropertyNode] {
        guard !isStaticOrClass else { return [] }

        let ownership = ownership

        return bindings.compactMap { binding -> PropertyNode? in
            guard binding.isStoredProperty,
                  let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                  let typeName = binding.typeAnnotation?.type.simpleTypeName else {
                return nil
            }

            return PropertyNode(name: name, type: .unresolved(typeName), ownership: ownership)
        }
    }
}

private extension VariableDeclSyntax {

    var isStaticOrClass: Bool {
        modifiers.contains { $0.name.text == "static" || $0.name.text == "class" }
    }

    var ownership: PropertyNode.Ownership {
        if modifiers.contains(where: { $0.name.text == "weak" }) {
            return .weak
        }
        if modifiers.contains(where: { $0.name.text == "unowned" }) {
            return .unowned
        }
        return .strong
    }
}

private extension PatternBindingSyntax {

    /// A binding is a stored property unless it has an accessor block that
    /// defines a getter (an implicit getter-only shorthand, or an explicit
    /// `get`/`set`) — `willSet`/`didSet` observers don't make it computed.
    var isStoredProperty: Bool {
        guard let accessorBlock else { return true }

        switch accessorBlock.accessors {
        case .getter:
            return false
        case .accessors(let accessors):
            return accessors.allSatisfy {
                $0.accessorSpecifier.text == "willSet" || $0.accessorSpecifier.text == "didSet"
            }
        }
    }
}

private extension TypeSyntax {

    /// The referenced type's name, or `nil` for anything other than a plain,
    /// non-generic named type (arrays, dictionaries, generics, tuples, etc.
    /// are out of scope for retain-cycle detection's first slice).
    var simpleTypeName: String? {
        if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return identifierType.genericArgumentClause == nil ? identifierType.name.text : nil
        }
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.simpleTypeName
        }
        return nil
    }
}
