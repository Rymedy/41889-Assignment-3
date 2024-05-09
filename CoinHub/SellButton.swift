//
//  BuyButton.swift
//  CoinHub
//
//  Created by Richard Webb on 1/5/2024.
//

import UIKit

class SellButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 0/255, blue: 110/255, alpha: 1.0).cgColor,
            UIColor(red: 135/255, green: 23/255, blue: 0/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 7.5
        layer.insertSublayer(gradientLayer, at: 0)
        setTitleColor(.white, for: .normal)
    }
}
