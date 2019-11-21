//
//  PredictionVerifier.swift
//  UXSketchLabelTests
//
//  Created by Christian Schnorr on 17.02.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import Foundation
import XCTest

class PredictionVerifier {
    public init(factory: FontFactory, prefix: String) {
        self.factory = factory
        self.prefix = prefix

        for row in PredictionVerifier.parseCSV(named: "\(prefix)-LineHeight") {
            self.expectedNaturalLineHeights.append((row[0], row[1]))
        }

        for row in PredictionVerifier.parseCSV(named: "\(prefix)-BaselineNatural") {
            self.expectedBaselineOffsetsWithNaturalLineHeight.append((row[0], row[1]))
        }

        for row in PredictionVerifier.parseCSV(named: "\(prefix)-BaselineExplicit") {
            self.expectedBaselineOffsetsWithExplicitLineHeight.append((row[0], row[1], row[2]))
        }
    }

    private let factory: FontFactory
    private let prefix: String

    private var expectedNaturalLineHeights: [(Int, Int)] = []
    private var expectedBaselineOffsetsWithNaturalLineHeight: [(Int, Int)] = []
    private var expectedBaselineOffsetsWithExplicitLineHeight: [(Int, Int, Int)] = []

    public func verifyNaturalLineHeightPredictions() {
        for (pointSize, expected) in self.expectedNaturalLineHeights {
            let font = self.factory.font(withSize: CGFloat(pointSize))
            let predicted = font.predictedNaturalLineHeight

            XCTAssertEqual(predicted, CGFloat(expected))
        }
    }

    public func verifyBaselineInNaturalLineHeightPredictions() {
        for (pointSize, expected) in self.expectedBaselineOffsetsWithNaturalLineHeight {
            let font = self.factory.font(withSize: CGFloat(pointSize))
            let predicted = font.predictedBaselineFromBottomEdgeWithImplicitLineHeight

            XCTAssertEqual(predicted, CGFloat(expected))
        }
    }

    public func verifyBaselineInExplicitLineHeightPredictions() {
        for (pointSize, lineHeight, expected) in self.expectedBaselineOffsetsWithExplicitLineHeight {
            let font = self.factory.font(withSize: CGFloat(pointSize))
            let predicted = font.predictedBaselineFromBottomEdge(withExplicitLineHeight: CGFloat(lineHeight))

            XCTAssertEqual(predicted, CGFloat(expected))
        }
    }

    private static func parseCSV(named filename: String) -> [[Int]] {
        let bundle = Bundle(for: self)
        let url = bundle.url(forResource: filename, withExtension: "csv")!
        let data = try! Data(contentsOf: url)
        let text = String(data: data, encoding: .utf8)!

        var rows: [[Int]] = []

        for line in text.components(separatedBy: .newlines).dropFirst() where !line.isEmpty {
            rows.append(line.components(separatedBy: ", ").map({ Int($0)! }))
        }

        return rows
    }
}
