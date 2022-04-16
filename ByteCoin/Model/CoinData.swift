//
//  CoinData.swift
//  ByteCoin
//
//  Created by Harrison Schick on 5/20/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let rate: Double
    let asset_id_base: String
    let asset_id_quote: String
}

