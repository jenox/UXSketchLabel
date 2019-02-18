//
//  FontFactory.swift
//  UXSketchLabelTests
//
//  Created by Christian Schnorr on 17.02.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import Foundation
import AppKit

class FontFactory {
    public init(named name: String) {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: nil)!
        let data = try! Data(contentsOf: url)

        let provider = CGDataProvider(data: data as CFData)!
        let font = CGFont(provider)!

        self.filename = name
        self.font = font
    }

    private let filename: String
    private let font: CGFont

    public func font(withSize size: CGFloat) -> NSFont {
        return CTFontCreateWithGraphicsFont(self.font, size, nil, nil)
    }
}
