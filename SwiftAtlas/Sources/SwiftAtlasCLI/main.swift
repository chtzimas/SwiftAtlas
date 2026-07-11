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
    let classes = try analyzer.analyze(filePath: path)
    for className in classes {
        print("Found class: \(className)")
    }
} catch {
    print("Error: \(error)")
}
