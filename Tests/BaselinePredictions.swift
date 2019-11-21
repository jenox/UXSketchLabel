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
        return round(self.ascender) - round(self.descender)
    }

    public var predictedBaselineFromBottomEdgeWithImplicitLineHeight: CGFloat {
        return round(-self.descender)
    }

    public func predictedBaselineFromBottomEdge(withExplicitLineHeight lineHeight: CGFloat) -> CGFloat {
        return fmax(0, round((lineHeight - (self.ascender - self.descender)) / 2 - self.leading - self.descender))
    }
}
