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
    
    let classes = analyzer.analyze(source: source)
    for className in classes {
        print("Found class: \(className)")
    }
} catch {
    print("Error: \(error)")
}
