//
//  ViewController.swift
//  UXSketchLabel
//
//  Created by Christian Schnorr on 17.02.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.view.addSubview(self.marker)
        self.view.addSubview(self.label)
        self.view.addSubview(self.slider)

        self.label.text = "Lorem"
        self.label.layer.borderColor = UIColor.red.cgColor
        self.label.layer.borderWidth = 1 / UIScreen.main.scale
        self.label.layer.cornerRadius = 2
        self.label.layer.masksToBounds = true
        self.label.numberOfLines = 3
        self.label.textColor = .blue

        self.slider.minimumValue = 20
        self.slider.maximumValue = 150
        self.slider.value = 30
        self.slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.label.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.label.mark(self.label.firstBaselineAnchor, color: .red)
        self.label.mark(self.label.lastBaselineAnchor, color: .red)

        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.slider.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.slider.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.slider.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true

        self.marker.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
        self.marker.translatesAutoresizingMaskIntoConstraints = false
        self.marker.topAnchor.constraint(equalTo: self.label.topAnchor).isActive = true
        self.marker.leftAnchor.constraint(equalTo: self.label.leftAnchor).isActive = true
        self.marker.rightAnchor.constraint(equalTo: self.label.rightAnchor).isActive = true
        self.marker.bottomAnchor.constraint(equalTo: self.label.bottomAnchor).isActive = true

        self.sliderDidChange()
    }

    private let label = UXSketchLabel()
    private let slider = UISlider()
    private let marker = UIView()

    @objc private func sliderDidChange() {
        let pointSize = CGFloat(round(self.slider.value))
        let font = UIFont.systemFont(ofSize: pointSize, weight: .medium)

        self.label.font = font
    }
}

extension UILayoutGuide {
    public func mark(_ color: UIColor) {
        let marker = UIView()
        marker.backgroundColor = color //.withAlphaComponent(0.1)
        self.owningView!.addSubview(marker)

        marker.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        marker.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        marker.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        marker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

extension UIView {
    public func mark(_ anchor: NSLayoutYAxisAnchor, color: UIColor = .blue) {
        let top = UIView()
        top.backgroundColor = color
        self.addSubview(top)
        top.translatesAutoresizingMaskIntoConstraints = false
        top.bottomAnchor.constraint(equalTo: anchor, constant: 0.5).isActive = true
        top.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        top.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        top.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }

    public func mark(_ guide: UILayoutGuide, color: UIColor) {
        let marker = UIView()
        marker.backgroundColor = color
        self.addSubview(marker)
        marker.translatesAutoresizingMaskIntoConstraints = false
        marker.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        marker.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        marker.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        marker.heightAnchor.constraint(equalTo: guide.heightAnchor).isActive = true
    }
}
