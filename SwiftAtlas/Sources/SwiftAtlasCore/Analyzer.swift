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

    public func analyze(package directory: URL) throws -> [ModuleNode] {
        let manifest = try packageManifest(at: directory)

        var modules: [ModuleNode] = []
        for target in manifest.targets {
            guard let targetDirectory = sourceDirectory(for: target, packageDirectory: directory),
                  FileManager.default.fileExists(atPath: targetDirectory.path) else {
                continue
            }

            let sourceFiles = try analyze(directory: targetDirectory)
            modules.append(ModuleNode(name: target.name, sourceFiles: sourceFiles))
        }

        return modules.sorted { $0.name < $1.name }
    }
}

private extension Analyzer {

    struct PackageManifest: Decodable {
        let targets: [Target]

        struct Target: Decodable {
            let name: String
            let type: String
            let path: String?
        }
    }

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

    func packageManifest(at directory: URL) throws -> PackageManifest {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", "package", "--package-path", directory.path, "dump-package"]

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        let outputData = try outputPipe.fileHandleForReading.readToEnd() ?? Data()

        guard process.terminationStatus == 0 else {
            let errorData = try errorPipe.fileHandleForReading.readToEnd() ?? Data()
            let message = String(data: errorData, encoding: .utf8) ?? "Unknown error"
            throw AnalyzerError.packageManifestReadFailed(message)
        }

        return try JSONDecoder().decode(PackageManifest.self, from: outputData)
    }

    func sourceDirectory(for target: PackageManifest.Target, packageDirectory: URL) -> URL? {
        if let path = target.path {
            return packageDirectory.appendingPathComponent(path)
        }

        switch target.type {
        case "regular", "executable", "macro", "plugin":
            return packageDirectory.appendingPathComponent("Sources").appendingPathComponent(target.name)
        case "test":
            return packageDirectory.appendingPathComponent("Tests").appendingPathComponent(target.name)
        default:
            return nil
        }
    }
}
