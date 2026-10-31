//
//  main.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/7/26.
//

import Foundation
import SwiftAtlasCore

do {
    let arguments = CommandLine.arguments

    guard arguments.count == 2 else {
        print("Wrong number of arguments. Usage: swift run swiftatlas <swift_file_or_directory_path>")
        exit(1)
    }

    let path = arguments[1]
    var isDirectory: ObjCBool = false
    guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else {
        print("No file or directory found at path: \(path)")
        exit(1)
    }

    let analyzer = Analyzer()

    if isDirectory.boolValue {
        let directoryURL = URL(fileURLWithPath: path)
        let packageManifestPath = directoryURL.appendingPathComponent("Package.swift").path

        if FileManager.default.fileExists(atPath: packageManifestPath) {
            let project = try analyzer.analyze(package: directoryURL)
            printResults(for: project)

            let graph = DependencyGraph(project: project)
            let cycles = CycleDetector().detectCycles(in: graph)
            printCycles(cycles)

            if !cycles.isEmpty {
                exit(1)
            }
        } else {
            let sourceFiles = try analyzer.analyze(directory: directoryURL)
            sourceFiles.forEach(printResults(for:))
        }
    } else {
        let source = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
        printResults(for: analyzer.analyze(source: source))
    }
} catch {
    print("Error: \(error)")
    exit(1)
}

func printResults(for project: ProjectNode) {
    guard project.hasDeclarations else { return }

    print("Project: \(project.name)")
    project.modules.forEach(printResults(for:))
}

func printCycles(_ cycles: [Cycle]) {
    guard !cycles.isEmpty else { return }

    print("========================================================")
    print("Detected \(cycles.count) potential retain cycle(s):")
    cycles.forEach { cycle in
        let names = (cycle.path + [cycle.path[0]]).map { "\($0.module).\($0.name)" }
        print("  " + names.joined(separator: " -> "))
    }
}

func printResults(for module: ModuleNode) {
    guard module.hasDeclarations else { return }

    print("Module: \(module.name)")
    module.sourceFiles.forEach(printResults(for:))
}

func printResults(for sourceFile: SourceFileNode) {
    guard sourceFile.hasDeclarations else { return }

    sourceFile.classes.forEach {
        print("========================================================")
        print("Found class: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.map(\.name).joined(separator: ", "))")
        }
    }
    sourceFile.structs.forEach {
        print("========================================================")
        print("Found struct: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.map(\.name).joined(separator: ", "))")
        }
    }
    sourceFile.enums.forEach {
        print("========================================================")
        print("Found enum: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.map(\.name).joined(separator: ", "))")
        }
    }
    sourceFile.protocols.forEach {
        print("========================================================")
        print("Found protocol: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.map(\.name).joined(separator: ", "))")
        }
    }
    print("========================================================")
}
