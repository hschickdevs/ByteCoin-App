//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didGetCoin(_ coinManager: CoinManager, currency: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "?apikey=916D706A-C9A4-4D81-A94E-882DA3492958"
    //finalurl = "\(baseURL)\(currencyArray[row])\(apiKey)"
    
    let currencyArray = ["USD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","AUD","ZAR"]

    func getCoinPrice(for currency: String) {
        print("You're out of API calls bro")
        let urlString = "\(baseURL)\(currency)\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didGetCoin(self, currency: coin)
                        print(coin)
                        print(coin.rate)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let base = decodedData.asset_id_base
            let country = decodedData.asset_id_quote
            
            let coin = CoinModel(rate: rate, coinBase: base, coinCountry: country)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
