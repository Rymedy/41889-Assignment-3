//
//  BuyButton.swift
//  CoinHub
//
//  Created by Richard Webb on 1/5/2024.
//

import UIKit

class BuyButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 255/255, blue: 110/255, alpha: 1.0).cgColor,
            UIColor(red: 43/255, green: 135/255, blue: 83/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 7.5
        layer.insertSublayer(gradientLayer, at: 0)
        setTitleColor(.white, for: .normal)
    }
}
