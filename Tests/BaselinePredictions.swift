//
//  BaselinePredictions.swift
//  UXSketchLabelTests
//
//  Created by Christian Schnorr on 17.02.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import AppKit

extension NSFont {
    public var predictedNaturalLineHeight: CGFloat {
        return 0
    }

    public var predictedBaselineFromBottomEdgeWithImplicitLineHeight: CGFloat {
        return 0
    }

    public func predictedBaselineFromBottomEdge(withExplicitLineHeight lineHeight: CGFloat) -> CGFloat {
        return 0
    }
}
