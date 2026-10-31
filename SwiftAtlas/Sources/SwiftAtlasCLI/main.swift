//
//  main.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/7/26.
//

import Foundation
import SwiftAtlasCore

let usage = "Usage: swift run swiftatlas <path> [--base <path>]"

do {
    let arguments = Array(CommandLine.arguments.dropFirst())

    guard let path = arguments.first else {
        print("Wrong number of arguments. \(usage)")
        exit(1)
    }

    let basePath = parseBasePath(from: Array(arguments.dropFirst()))

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
            let headGraph = DependencyGraph(project: try analyzer.analyze(package: directoryURL))

            if let basePath {
                let baseGraph = DependencyGraph(project: try analyzer.analyze(package: URL(fileURLWithPath: basePath)))
                let newCycles = CycleDetector().detectNewCycles(in: headGraph, comparedTo: baseGraph)
                printNewCycles(newCycles)

                if !newCycles.isEmpty {
                    exit(1)
                }
            } else {
                let cycles = CycleDetector().detectCycles(in: headGraph)
                printCycles(cycles)

                if !cycles.isEmpty {
                    exit(1)
                }
            }
        } else if basePath != nil {
            print("--base is only supported when <path> is a Swift package (a directory containing Package.swift).")
            exit(1)
        } else {
            let sourceFiles = try analyzer.analyze(directory: directoryURL)
            sourceFiles.forEach(printResults(for:))
        }
    } else if basePath != nil {
        print("--base is only supported when <path> is a Swift package (a directory containing Package.swift).")
        exit(1)
    } else {
        let source = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
        printResults(for: analyzer.analyze(source: source))
    }
} catch {
    print("Error: \(error)")
    exit(1)
}

func parseBasePath(from remainingArguments: [String]) -> String? {
    guard !remainingArguments.isEmpty else { return nil }

    guard remainingArguments.count == 2, remainingArguments[0] == "--base" else {
        print("Wrong number of arguments. \(usage)")
        exit(1)
    }

    return remainingArguments[1]
}

func printCycles(_ cycles: [Cycle]) {
    guard !cycles.isEmpty else {
        print("No potential retain cycles detected.")
        return
    }

    print("Detected \(cycles.count) potential retain cycle(s):")
    printCyclePaths(cycles)
}

func printNewCycles(_ cycles: [Cycle]) {
    guard !cycles.isEmpty else {
        print("No newly introduced potential retain cycles detected.")
        return
    }

    print("Detected \(cycles.count) newly introduced potential retain cycle(s):")
    printCyclePaths(cycles)
}

func printCyclePaths(_ cycles: [Cycle]) {
    cycles.forEach { cycle in
        let names = (cycle.path + [cycle.path[0]]).map { "\($0.module).\($0.name)" }
        print("  " + names.joined(separator: " -> "))
    }
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
