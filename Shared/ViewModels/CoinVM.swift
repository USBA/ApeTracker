//
//  CoinVM.swift
//  CoinTracker
//
//  Created by Umayanga Alahakoon on 2022-03-20.
//

import SwiftUI

class CoinVM: ObservableObject {
    @Published var coinPrice: String = ""
    @Published var isLoading = false
    
    let generator = UINotificationFeedbackGenerator()
}

extension CoinVM {
    // MARK: Get Coin Price API Call
    func fetchCoinPrice(symbol: String) async {
        
        guard let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=\(symbol)") else {
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coin = try JSONDecoder().decode(Coin.self, from: data)
            print("fetchCoinPrice - response: \(coin)")
            DispatchQueue.main.async {
                self.coinPrice = coin.price ?? ""
                self.isLoading = false
            }
        } catch {
            print("fetchCoinPrice - response - error : \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
                // indicate error with vibration
                self.generator.notificationOccurred(.error)
            }
        }
    }
    
}
