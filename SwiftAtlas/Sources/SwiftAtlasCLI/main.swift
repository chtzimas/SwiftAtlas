//
//  main.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 2/7/26.
//

import Foundation
import SwiftAtlasCore

let path = "Samples/Test.swift"

let analyzer = Analyzer()

do {
    let url = URL(fileURLWithPath: "Samples/Test.swift")
    let source = try String(contentsOf: url, encoding: .utf8)

    let classes = analyzer.analyze(source: source)
    for className in classes {
        print("Found class: \(className)")
    }
} catch {
    print("Error: \(error)")
}
