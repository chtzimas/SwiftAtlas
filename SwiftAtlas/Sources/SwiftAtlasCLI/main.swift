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
        print("Wrong number of arguments. Usage: swift run swiftatlas <swift_file_path>")
        exit(1)
    }

    let filePath = arguments[1]
    let source = try String(contentsOf: URL(fileURLWithPath: filePath), encoding: .utf8)
    let analyzer = Analyzer()
    
    let sourceFile = analyzer.analyze(source: source)
    sourceFile.classes.forEach {
        print("========================================================")
        print("Found class: \($0.name)")
        if $0.hasInheritance {
            print("Inherits from: \($0.inheritedTypes.joined(separator: ", "))")
        }
    }
    print("========================================================")
} catch {
    print("Error: \(error)")
}
