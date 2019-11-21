/*
 MIT License

 Copyright (c) 2019 Christian Schnorr

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit


/**
 * A drop-in replacement for `UILabel` that behaves more like text layers in
 * Sketch do.
 *
 * Using instances of this class over `UILabel` has the following benefits:
 *
 * - Convenient line height configuration
 * - Uniform line height for multiline labels
 * - Consistent baseline placement with Sketch
 * - Support for small line heights without clipping text
 *
 * Most importantly though, you get to configure your layout with the same
 * properties your designer uses in Sketch, and you are guaranteed the exact
 * result your designer intended, without hours of manually measuring baseline
 * offsets and pushing pixels around.
 *
 * Note that the label's height and baseline offset are rounded to _points_ as
 * they are in Sketch to ensure consistent layouts across 1x, 2x and 3x devices.
 *
 * As a result, you may not want to use it everywhere in your app. For example,
 * if you want text to be perfectly centered vertically around some reference
 * value, such as a y-axis label of a graph, you may want to use something else.
 *
 *
 * - Author: christian.schnorr@me.com
 */
public final class UXSketchLabel: UILabel {

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.createBaselineLayoutConstraints()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }


    // MARK: - Configuration

    public var lineHeight: CGFloat? = 50 {
        didSet { self.invalidateIntrinsicContentSize() }
    }


    // MARK: - Attributed String Management

    private var needsUpdateAttributedString: Bool = false
    private var isUpdatingAttributedString: Bool = false

    private func updateAttributedStringIfNeeded() {
        guard self.needsUpdateAttributedString else { return }

        self.needsUpdateAttributedString = false
        self.isUpdatingAttributedString = true

        self.updateAttributedString()

        self.isUpdatingAttributedString = false
    }

    private func updateAttributedString() {
        let lineHeight = self.effectiveLineHeight

        if let attributedText = self.attributedText {
            let attributedText = NSMutableAttributedString(attributedString: attributedText)
            let range = NSRange(location: 0, length: attributedText.length)

            attributedText.enumerateAttribute(.paragraphStyle, in: range, options: [], using: { value, range, _ in
                let style = (value as? NSParagraphStyle)?.mutableCopy() as? NSMutableParagraphStyle ?? .init()
                style.minimumLineHeight = lineHeight
                style.maximumLineHeight = lineHeight

                attributedText.addAttribute(.paragraphStyle, value: style, range: range)
            })

            super.attributedText = attributedText
        }
    }


    // MARK: - Auto Layout

    private let baselineLayoutGuide = UILayoutGuide()

    private var firstBaselineFromTopEdgeConstraint: NSLayoutConstraint? = nil
    private var lastBaselineFromBottomEdgeConstraint: NSLayoutConstraint? = nil

    private func createBaselineLayoutConstraints() {
        self.addLayoutGuide(self.baselineLayoutGuide)

        let top = self.baselineLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor)
        let left = self.baselineLayoutGuide.leftAnchor.constraint(equalTo: self.leftAnchor)
        let right = self.baselineLayoutGuide.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bottom = self.baselineLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        self.firstBaselineFromTopEdgeConstraint = top
        self.lastBaselineFromBottomEdgeConstraint = bottom

        NSLayoutConstraint.activate([top, left, right, bottom])
    }

    public override func invalidateIntrinsicContentSize() {
        if !self.isUpdatingAttributedString {
            self.needsUpdateAttributedString = true
        }

        super.invalidateIntrinsicContentSize()
    }

    public override var alignmentRectInsets: UIEdgeInsets {
        let lineHeight = self.effectiveLineHeight
        let baselineInset = self.lastBaselineInsetFromBottomEdge

        // Sketch allows labels to draw outside of their alignment rect, thus we
        // need to manually inset said alignment rect to ensure that neither
        // ascenders nor descenders get clipped.
        let top = max(0, ceil(self.font.ascender) - (lineHeight - baselineInset))
        let bottom = max(0, ceil(-self.font.descender) - baselineInset)

        return UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    }

    public override func updateConstraints() {
        self.updateAttributedStringIfNeeded()

        super.updateConstraints()

        let lineHeight = self.effectiveLineHeight
        let baselineInset = self.lastBaselineInsetFromBottomEdge

        self.firstBaselineFromTopEdgeConstraint?.constant = -baselineInset + lineHeight
        self.lastBaselineFromBottomEdgeConstraint?.constant = -baselineInset
    }

    public override var firstBaselineAnchor: NSLayoutYAxisAnchor {
        return self.baselineLayoutGuide.topAnchor
    }

    public override var lastBaselineAnchor: NSLayoutYAxisAnchor {
        return self.baselineLayoutGuide.bottomAnchor
    }


    // MARK: - Text Rendering

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        self.updateAttributedStringIfNeeded()

        let inherited = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)

        return self.frame(forAlignmentRect: inherited)
    }

    public override func drawText(in rect: CGRect) {

        // start with alignment rect
        var rect = self.alignmentRect(forFrame: self.bounds)

        // move last baseline to bottom of alignment rect
        let scale = self.window?.screen.scale ?? UIScreen.main.scale
        let dy = round(-self.font.descender * scale) / scale
        rect = rect.offsetBy(dx: 0, dy: dy)

        // move baseline to where Sketch wants it
        rect = rect.offsetBy(dx: 0, dy: -self.lastBaselineInsetFromBottomEdge)

        super.drawText(in: rect)
    }

    private var effectiveLineHeight: CGFloat {
        return round(self.lineHeight ?? self.naturalLineHeight)
    }

    private var naturalLineHeight: CGFloat {
        return round(self.font.ascender) - round(self.font.descender)
    }

    private var lastBaselineInsetFromBottomEdge: CGFloat {
        if let lineHeight = self.lineHeight {
            let ascender = self.font.ascender
            let descender = self.font.descender
            let leading = self.font.leading

            return fmax(0, round((lineHeight - (ascender - descender)) / 2 - leading - descender))
        }
        else {
            return round(-self.font.descender)
        }
    }
}
