//
//  ViewController.swift
//  CoinHub
//
//  Created by Richard Webb on 30/4/2024.
//

import UIKit

class ViewController: UIViewController, CryptoRectangleViewDelegate {
    var accountFunds = 50000.00
    var portfolioValue = 0.00
    var btcBalance = 0.00
    var ethBalance = 0.00
    var usdtBalance = 0.00
    var homeCurrency = "AUD"
    var portfolioValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let portfolioView = PortfolioRectangleView(frame: CGRect(x: 20, y: 75, width: 350, height: 200))
        portfolioView.backgroundColor = .white
        portfolioView.layer.cornerRadius = 25
        portfolioView.layer.masksToBounds = true
        view.addSubview(portfolioView)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.0).cgColor,
            UIColor(red: 136/255, green: 0/255, blue: 255/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)

        let titleLabel = UILabel(frame: CGRect(x: 35, y: 80, width: 200, height: 50))
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = "My Portfolio"
        view.addSubview(titleLabel)

        portfolioValueLabel = UILabel(frame: CGRect(x: 35, y: 185, width: 300, height: 30))
        portfolioValueLabel.textColor = .white
        portfolioValueLabel.font = UIFont.boldSystemFont(ofSize: 26)
        portfolioValueLabel.text = "\(portfolioValue) \(homeCurrency)"
        view.addSubview(portfolioValueLabel)

        let accountFundsLabel = UILabel(frame: CGRect(x: 110, y: 230, width: 350, height: 30))
        accountFundsLabel.textColor = .white
        accountFundsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        accountFundsLabel.text = "Account Funds: $\(accountFunds)"
        view.addSubview(accountFundsLabel)
        
        let btcOwnedLabel = UILabel(frame: CGRect(x: 165, y: 90, width: 350, height: 30))
        btcOwnedLabel.textColor = .white
        btcOwnedLabel.font = UIFont.boldSystemFont(ofSize: 15)
        btcOwnedLabel.text = "BTC Balance: \(btcBalance)"
        view.addSubview(btcOwnedLabel)
        
        let ethOwnedLabel = UILabel(frame: CGRect(x: 165, y: 120, width: 350, height: 30))
        ethOwnedLabel.textColor = .white
        ethOwnedLabel.font = UIFont.boldSystemFont(ofSize: 15)
        ethOwnedLabel.text = "ETH Balance: \(ethBalance)"
        view.addSubview(ethOwnedLabel)
        
        let usdtOwnedLabel = UILabel(frame: CGRect(x: 165, y: 150, width: 350, height: 30))
        usdtOwnedLabel.textColor = .white
        usdtOwnedLabel.font = UIFont.boldSystemFont(ofSize: 15)
        usdtOwnedLabel.text = "USDT Balance: \(usdtBalance)"
        view.addSubview(usdtOwnedLabel)

        let btcView = CryptoRectangleView(frame: CGRect(x: 20, y: 300, width: 350, height: 150), cryptoName: "BTC")
        btcView.delegate = self
        btcView.backgroundColor = .white
        btcView.layer.cornerRadius = 15
        btcView.layer.masksToBounds = true
        view.addSubview(btcView)

        let ethView = CryptoRectangleView(frame: CGRect(x: 20, y: 475, width: 350, height: 150), cryptoName: "ETH")
        ethView.delegate = self
        ethView.backgroundColor = .white
        ethView.layer.cornerRadius = 15
        ethView.layer.masksToBounds = true
        view.addSubview(ethView)

        let usdtView = CryptoRectangleView(frame: CGRect(x: 20, y: 650, width: 350, height: 150), cryptoName: "USDT")
        usdtView.delegate = self
        usdtView.backgroundColor = .white
        usdtView.layer.cornerRadius = 15
        usdtView.layer.masksToBounds = true
        view.addSubview(usdtView)
        updateAccountFundsLabel()
    }

    func didTapBuyButton(for cryptoID: String, withValue value: Double) {
        let alertController = UIAlertController(title: "Buy \(cryptoID)", message: "Enter amount in \(homeCurrency):", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter amount"
            textField.keyboardType = .decimalPad
        }

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let enteredAmountString = textField.text,
                  let enteredAmount = Double(enteredAmountString) else {
                return
            }
            
            if let accountFunds = self?.accountFunds, enteredAmount > accountFunds {
                let insufficientFundsAlert = UIAlertController(title: "Insufficient Account Funds", message: "You do not have enough funds to complete the purchase.", preferredStyle: .alert)
                insufficientFundsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(insufficientFundsAlert, animated: true, completion: nil)
                return
            }
            let numberOfTokens = enteredAmount / value
            self?.accountFunds -= enteredAmount
            
            switch cryptoID {
            case "BTC":
                self?.btcBalance += numberOfTokens
            case "ETH":
                self?.ethBalance += numberOfTokens
            case "USDT":
                self?.usdtBalance += numberOfTokens
            default:
                break
            }
            self?.portfolioValue += numberOfTokens * value

            self?.updateAccountFundsLabel()
            self?.updateCryptoBalances()
            self?.updatePortfolioValueLabel()
        }
        
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }

    func didTapSellButton(for cryptoID: String, withValue value: Double) {
        let alertController = UIAlertController(title: "Sell \(cryptoID)", message: "Enter amount in \(cryptoID):", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter amount"
            textField.keyboardType = .decimalPad
        }

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let enteredAmountString = textField.text,
                  let enteredAmount = Double(enteredAmountString) else {
                return
            }

            var cryptoBalance = 0.0
            switch cryptoID {
            case "BTC":
                cryptoBalance = self?.btcBalance ?? 0.0
            case "ETH":
                cryptoBalance = self?.ethBalance ?? 0.0
            case "USDT":
                cryptoBalance = self?.usdtBalance ?? 0.0
            default:
                break
            }

            if enteredAmount > cryptoBalance {
                let insufficientCryptoAlert = UIAlertController(title: "Insufficient \(cryptoID) Balance", message: "You do not have enough \(cryptoID) to complete the sale.", preferredStyle: .alert)
                insufficientCryptoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(insufficientCryptoAlert, animated: true, completion: nil)
                return
            }

            let amountToReceive = enteredAmount * value

            self?.accountFunds += amountToReceive
            switch cryptoID {
            case "BTC":
                self?.btcBalance -= enteredAmount
            case "ETH":
                self?.ethBalance -= enteredAmount
            case "USDT":
                self?.usdtBalance -= enteredAmount
            default:
                break
            }

            self?.portfolioValue -= amountToReceive

            self?.updateAccountFundsLabel()
            self?.updateCryptoBalances()
            self?.updatePortfolioValueLabel()
        }

        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }

    private func updateAccountFundsLabel() {
        if let accountFundsLabel = view.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text?.hasPrefix("Account Funds: $") ?? false }) {
            accountFundsLabel.text = "Account Funds: $" + String(format: "%.2f", accountFunds)
        }
    }
    private func updatePortfolioValueLabel() {
        let btcPrice = 97288.19
        let ethPrice = 4863.25
        let usdtPrice = 1.53

        let btcValue = btcBalance * btcPrice
        let ethValue = ethBalance * ethPrice
        let usdtValue = usdtBalance * usdtPrice

        let totalPortfolioValue = btcValue + ethValue + usdtValue
        
        let formattedTotalPortfolioValue = String(format: "%.2f", totalPortfolioValue)

        portfolioValueLabel.text = "\(formattedTotalPortfolioValue) \(homeCurrency)"
    }

    private func updateCryptoBalances() {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 9

        if let btcOwnedLabel = view.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text?.hasPrefix("BTC Balance:") ?? false }) {
            btcOwnedLabel.text = "BTC Balance: \(formatter.string(from: btcBalance as NSNumber) ?? "")"
        }
        formatter.maximumFractionDigits = 8
        if let ethOwnedLabel = view.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text?.hasPrefix("ETH Balance:") ?? false }) {
            ethOwnedLabel.text = "ETH Balance: \(formatter.string(from: ethBalance as NSNumber) ?? "")"
        }
        formatter.maximumFractionDigits = 4
        if let usdtOwnedLabel = view.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text?.hasPrefix("USDT Balance:") ?? false }) {
            usdtOwnedLabel.text = "USDT Balance: \(formatter.string(from: usdtBalance as NSNumber) ?? "")"
        }
    }

}
