//
//  Analyzer.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/7/26.
//

import Foundation
import SwiftParser
import SwiftSyntax

public final class Analyzer {

    public init() {}

    public func analyze(source: String) -> SourceFileNode {
        let sourceFile = Parser.parse(source: source)

        let classVisitor = ClassVisitor(viewMode: .sourceAccurate)
        classVisitor.walk(sourceFile)

        let structVisitor = StructVisitor(viewMode: .sourceAccurate)
        structVisitor.walk(sourceFile)

        let enumVisitor = EnumVisitor(viewMode: .sourceAccurate)
        enumVisitor.walk(sourceFile)

        let protocolVisitor = ProtocolVisitor(viewMode: .sourceAccurate)
        protocolVisitor.walk(sourceFile)

        return SourceFileNode(
            classes: classVisitor.classes,
            structs: structVisitor.structs,
            enums: enumVisitor.enums,
            protocols: protocolVisitor.protocols
        )
    }

    public func analyze(directory: URL) throws -> [SourceFileNode] {
        try swiftFileURLs(in: directory).map { url in
            let source = try String(contentsOf: url, encoding: .utf8)
            return analyze(source: source)
        }
    }
}

private extension Analyzer {

    func swiftFileURLs(in directory: URL) -> [URL] {
        let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        let urls = enumerator?.compactMap { $0 as? URL } ?? []

        return urls
            .filter { $0.pathExtension == "swift" }
            .sorted { $0.path < $1.path }
    }
}
