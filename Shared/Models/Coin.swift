//
//  Coin.swift
//  CoinTracker
//
//  Created by Umayanga Alahakoon on 2022-03-20.
//

import Foundation

// MARK: - Welcome
struct Coin: Codable {
    let time: String?
    let assetIDBase: String?
    let assetIDQuote: String?
    let rate: Double?
    //let srcSideBase: [SrcSideBase]
    
    enum CodingKeys: String, CodingKey {
        case time
        case assetIDBase = "asset_id_base"
        case assetIDQuote = "asset_id_quote"
        case rate
        //case srcSideBase = "src_side_base"
    }
}

//// MARK: - SrcSideBase
//struct SrcSideBase: Codable {
//    let time, asset: String
//    let rate, volume: Double
//}
