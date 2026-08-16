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

    let sourceFiles: [SourceFileNode]
    if isDirectory.boolValue {
        sourceFiles = try analyzer.analyze(directory: URL(fileURLWithPath: path))
    } else {
        let source = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
        sourceFiles = [analyzer.analyze(source: source)]
    }

    sourceFiles.forEach(printResults(for:))
} catch {
    print("Error: \(error)")
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
