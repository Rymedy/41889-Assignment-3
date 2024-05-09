//
//  CryptoRectangleView.swift
//  CoinHub
//
//  Created by Richard Webb on 30/4/2024.
//

import UIKit

protocol CryptoRectangleViewDelegate: AnyObject {
    func didTapBuyButton(for cryptoID: String, withValue value: Double)
    func didTapSellButton(for cryptoID: String, withValue value: Double)
}

class CryptoRectangleView: UIView {
    weak var delegate: CryptoRectangleViewDelegate?
    var cryptoID = ""
    var btcValue = 97288.19
    var ethValue = 4863.25
    var usdtValue = 1.53
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Waits 50 ms before calling the setupUI method in order to wait for cryptoID to be set initially
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.setupUI()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupUI()
        }
    }
    
    convenience init(frame: CGRect, cryptoName: String) {
        self.init(frame: frame)
        self.cryptoID = cryptoName
    }
    
    private func setupUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        switch cryptoID {
        case "BTC":
            gradientLayer.colors = [
                UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0).cgColor,
                UIColor(red: 255/255, green: 94/255, blue: 0/255, alpha: 1.0).cgColor
            ]
        case "ETH":
            gradientLayer.colors = [
                UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor,
                UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0).cgColor
            ]
        case "USDT":
            gradientLayer.colors = [UIColor.green.cgColor, UIColor.blue.cgColor]
        default:
            gradientLayer.colors = [
                UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0).cgColor,
                UIColor(red: 255/255, green: 94/255, blue: 0/255, alpha: 1.0).cgColor
            ]
        }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        
        let iconImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        switch cryptoID {
        case "BTC":
            iconImageView.image = UIImage(named: "BTC")
        case "ETH":
            iconImageView.image = UIImage(named: "ETH")
        case "USDT":
            iconImageView.image = UIImage(named: "USDT")
        default:
            iconImageView.image = UIImage(named: "BTC")
        }
        addSubview(iconImageView)
        
        switch cryptoID {
        case "BTC":
            let cryptoNameLabel = UILabel(frame: CGRect(x: bounds.maxX - 120, y: 10, width: 200, height: 30))
            cryptoNameLabel.textColor = .black
            cryptoNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cryptoNameLabel.text = "Bitcoin (BTC)"
            addSubview(cryptoNameLabel)
        case "ETH":
            let cryptoNameLabel = UILabel(frame: CGRect(x: bounds.maxX - 140, y: 10, width: 200, height: 30))
            cryptoNameLabel.textColor = .black
            cryptoNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cryptoNameLabel.text = "Ethereum (ETH)"
            addSubview(cryptoNameLabel)
        case "USDT":
            let cryptoNameLabel = UILabel(frame: CGRect(x: bounds.maxX - 120, y: 10, width: 200, height: 30))
            cryptoNameLabel.textColor = .black
            cryptoNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cryptoNameLabel.text = "Tether (USDT)"
            addSubview(cryptoNameLabel)
        default:
            let cryptoNameLabel = UILabel(frame: CGRect(x: bounds.maxX - 135, y: 10, width: 200, height: 30))
            cryptoNameLabel.textColor = .black
            cryptoNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cryptoNameLabel.text = "Bitcoin (BTC)"
            addSubview(cryptoNameLabel)
        }
        
        let priceLabel = UILabel(frame: CGRect(x: 20, y: 80, width: 100, height: 30))
        priceLabel.textColor = .black
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        switch cryptoID {
        case "BTC":
            priceLabel.text = "$\(btcValue)"
        case "ETH":
            priceLabel.text = "$\(ethValue)"
        case "USDT":
            priceLabel.text = "$\(usdtValue)"
        default:
            priceLabel.text = "$\(btcValue)"
        }
        addSubview(priceLabel)

        let buyButton = BuyButton(type: .system)
        buyButton.frame = CGRect(x: bounds.maxX - 195, y: 105, width: 80, height: 30)
        buyButton.setTitle("BUY", for: .normal)
        buyButton.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
        addSubview(buyButton)
        
        let sellButton = SellButton(type: .system)
        sellButton.frame = CGRect(x: bounds.maxX - 100, y: 105, width: 80, height: 30)
        sellButton.setTitle("SELL", for: .normal)
        sellButton.addTarget(self, action: #selector(sellButtonPressed), for: .touchUpInside)
        addSubview(sellButton)
    }

    @objc private func buyButtonPressed() {
        delegate?.didTapBuyButton(for: cryptoID, withValue: getPriceForCryptoID())
    }
    @objc private func sellButtonPressed() {
        delegate?.didTapSellButton(for: cryptoID, withValue: getPriceForCryptoID())
    }

    private func getPriceForCryptoID() -> Double {
        switch cryptoID {
        case "BTC":
            return btcValue
        case "ETH":
            return ethValue
        case "USDT":
            return usdtValue
        default:
            return btcValue
        }
    }
}
