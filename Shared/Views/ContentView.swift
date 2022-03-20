//
//  ContentView.swift
//  Shared
//
//  Created by Umayanga Alahakoon on 2022-03-20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coinVM = CoinVM()
    @AppStorage("trackingSymbol") var trackingSymbol = "APE"
    
    
    var body: some View {
        ZStack {
            
            Image("ApeCoin_Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .blur(radius: 50)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                Image("ApeCoin_Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 175, height: 175)
                    .shadow(radius: 30)
                    .onLongPressGesture {
                        refreshCoinPrice()
                    }
                    .padding(.bottom, 60)
                
                Text(coinVM.coinPrice.formatted(.number))
                    .font(.system(size: 60, design: .default))
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Text("USD")
                    .font(.system(size: 30, design: .default))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.75))
            }
            .foregroundColor(.white)
            .padding(35)
        }
        .preferredColorScheme(.dark)
        .task {
            await coinVM.fetchCoinPrice(symbol: trackingSymbol)
        }
    }
    
    func refreshCoinPrice() {
        if !coinVM.isLoading {
            // vibrate
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            coinVM.isLoading = true
            // api call
            Task {
                await coinVM.fetchCoinPrice(symbol: trackingSymbol)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
