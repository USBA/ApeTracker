//
//  ContentView.swift
//  Shared
//
//  Created by Umayanga Alahakoon on 2022-03-20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coinVM = CoinVM()
    // ape coin symbol on binance
    var trackingSymbol = "APEUSDT"
    
    // Links
    let apeCoinWebsite = URL(string: "https://apecoin.com")!
    let apeCoinContract = URL(string: "https://etherscan.io/token/0x4d224452801aced8b2f0aebe155379bb5d594381")!
    let appSourceCode = URL(string: "https://github.com/USBA/ApeTracker")!
    let binanceAPI = URL(string: "https://binance-docs.github.io/apidocs/spot/en/#symbol-price-ticker")!
    let developerTwitter = URL(string: "https://twitter.com/metaUSB")!
    
    var body: some View {
        ZStack {
            // background image
            Image("ApeCoin_Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 50)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                
                // ape coin logo
                Image("ApeCoin_Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 175, height: 175)
                    .shadow(radius: 30)
                    .onLongPressGesture {
                        refreshCoinPrice()
                    }
                    .padding(.bottom, 60)
                
                // ape coin price
                Text(Double(coinVM.coinPrice)?.formatted(.number) ?? "0.0000")
                    .font(.system(size: 60, design: .default))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .redacted(reason: coinVM.coinPrice.isEmpty ? .placeholder : [])
                
                // USD currency text
                Text("USD")
                    .font(.system(size: 30, design: .default))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.75))
                    .redacted(reason: coinVM.coinPrice.isEmpty ? .placeholder : [])
                
                Spacer()
                
                bottomMenu

            }
            .foregroundColor(.white)
            .padding(.horizontal, 35)
            .padding(.vertical, 20)
        }
        .preferredColorScheme(.dark)
        .task {
            await coinVM.fetchCoinPrice(symbol: trackingSymbol)
        }
    }
    
    // bottom menu with relevant links
    var bottomMenu: some View {
        Menu {
            Link(destination: developerTwitter) {
                Label("Developer", systemImage: "person")
            }
            Divider()
            Link(destination: binanceAPI) {
                Label("Binance Open API", systemImage: "antenna.radiowaves.left.and.right")
            }
            Link(destination: appSourceCode) {
                Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
            }
            Divider()
            Link(destination: apeCoinContract) {
                Label("ApeCoin Contract", systemImage: "scroll")
            }
            Link(destination: apeCoinWebsite) {
                Label("ApeCoin Website", systemImage: "network")
            }
        } label: {
            Image(systemName: "ellipsis")
                .imageScale(.large)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.white.opacity(0.25))
                .clipShape(Capsule())
        }
    }
    
    // get current price api call
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
