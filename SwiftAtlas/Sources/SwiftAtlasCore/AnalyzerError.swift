//
//  AnalyzerError.swift
//  SwiftAtlas
//
//  Created by Christos Tzimas on 16/8/26.
//

public enum AnalyzerError: Error, Equatable {
    case packageManifestReadFailed(String)
}
