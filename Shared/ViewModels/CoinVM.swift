//
//  CoinVM.swift
//  CoinTracker
//
//  Created by Umayanga Alahakoon on 2022-03-20.
//

import SwiftUI

class CoinVM: ObservableObject {
    @Published var coinPrice: Double = 0
    @Published var isLoading = false
    
    let apiKey = "87C3D5D1-3743-4E0D-B2DB-DADD405B01A3"
    let generator = UINotificationFeedbackGenerator()
}

extension CoinVM {
    // MARK: Get Coin Price API Call
    func fetchCoinPrice(symbol: String) async {
        
        guard let url = URL(string: "https://rest.coinapi.io/v1/exchangerate/\(symbol)/USD?apikey=\(apiKey)") else {
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coin = try JSONDecoder().decode(Coin.self, from: data)
            print("fetchCoinPrice - response: \(data)")
            DispatchQueue.main.async {
                self.coinPrice = coin.rate ?? 0
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
