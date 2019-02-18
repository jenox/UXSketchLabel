//
//  UXSketchLabelTests.swift
//  UXSketchLabelTests
//
//  Created by Christian Schnorr on 17.02.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import XCTest
import AppKit

class UXSketchLabelTests: XCTestCase {
    private let verifiers: [PredictionVerifier] = [
        PredictionVerifier(factory: FontFactory(named: "HelveticaNeue.ttc"), prefix: "HelveticaNeue"),
        PredictionVerifier(factory: FontFactory(named: "SanFrancisco-Text.otf"), prefix: "SanFrancisco-Text"),
        PredictionVerifier(factory: FontFactory(named: "SanFrancisco-Display.otf"), prefix: "SanFrancisco-Display"),
        PredictionVerifier(factory: FontFactory(named: "Lato.ttf"), prefix: "Lato"),
    ]

    public func testNaturalLineHeightPrediction() {
        for verifier in self.verifiers {
            verifier.verifyNaturalLineHeightPredictions()
        }
    }

    public func testBaselineInNaturalLineHeightPrediction() {
        for verifier in self.verifiers {
            verifier.verifyBaselineInNaturalLineHeightPredictions()
        }
    }

    public func testBaselineInExplicitLineHeightPrediction() {
        for verifier in self.verifiers {
            verifier.verifyBaselineInExplicitLineHeightPredictions()
        }
    }
}
