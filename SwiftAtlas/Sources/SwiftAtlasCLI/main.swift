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
            let modules = try analyzer.analyze(package: directoryURL)
            modules.forEach(printResults(for:))
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
            print("Inherits from: \($0.inheritedTypes.joined(separator: ", "))")
        }
    }
    sourceFile.structs.forEach {
        print("========================================================")
        print("Found struct: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.joined(separator: ", "))")
        }
    }
    sourceFile.enums.forEach {
        print("========================================================")
        print("Found enum: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.joined(separator: ", "))")
        }
    }
    sourceFile.protocols.forEach {
        print("========================================================")
        print("Found protocol: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.joined(separator: ", "))")
        }
    }
    print("========================================================")
}
