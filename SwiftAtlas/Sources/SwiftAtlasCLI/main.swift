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
    let result = try analyzer.analyze(filePath: path)
    print("SwiftAtlas CLI")
    print(result)
} catch {
    print("Error: \(error)")
}
