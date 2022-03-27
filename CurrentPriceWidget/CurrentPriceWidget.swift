//
//  CurrentPriceWidget.swift
//  CurrentPriceWidget
//
//  Created by Umayanga Alahakoon on 2022-03-27.
//

import WidgetKit
import SwiftUI
import Intents

struct SimpleEntry: TimelineEntry {
    let date: Date
    var coinPrice: String = ""
    let configuration: ConfigurationIntent
}

struct Provider: IntentTimelineProvider {
    // ape coin symbol on binance
    var trackingSymbol = "APEUSDT"
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), coinPrice: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), coinPrice: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        // api call
        fetchCoinPrice(symbol: trackingSymbol) { coin in
            let currentDate = Date.now
            
            let simpleEntry = SimpleEntry(date: currentDate, coinPrice: coin.price ?? "", configuration: configuration)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
            
            let timeline = Timeline(entries: [simpleEntry], policy: .after(nextUpdate))
            completion(timeline)
            
        }
    }
}

// Fetch current price of the provided symbol form Binance API
func fetchCoinPrice(symbol: String, completion: @escaping (Coin) -> ()) {
    guard let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=\(symbol)") else {
        print("Widget - Couldn't get the URL from String")
        return
    }
    
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: url) { data, _, error in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        do {
            if let data = data {
                let coin = try JSONDecoder().decode(Coin.self, from: data)
                print("Widget - fetchCoinPrice - response: \(coin)")
                completion(coin)
            } else {
                print("Widget - fetchCoinPrice - data is nil")
            }
            
        } catch {
            print(error.localizedDescription)
            return
        }
        
    }.resume()
}


struct CurrentPriceWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            // ape coin logo
            Image("ApeCoin_Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .shadow(radius: 30)
            
            // ape coin price
            Text(Double(entry.coinPrice)?.formatted(.number) ?? "0.0000")
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
            
            // USD currency text
            Text("USD")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.75))
                .lineLimit(1)
        }
        .foregroundColor(.white)
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(
            Image("ApeCoin_WidgetBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 40)
                .clipped()
        )
        .background(Color.black)
        
    }
}

@main
struct CurrentPriceWidget: Widget {
    let kind: String = "CurrentPriceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CurrentPriceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Current Price")
        .description("Shows the current price of ApeCoin")
    }
}

struct CurrentPriceWidget_Previews: PreviewProvider {
    static var previews: some View {
        CurrentPriceWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
