//
//  Double+CurrencyInputFormat.swift
//  ComprasUSA
//
//  Created by Matheus Coelho Espinasso on 20/10/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import Foundation

extension Double {
    
    func getCurrencyInputFormat(currencySymbol: String) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        let givenNumber = self
        
        return formatter.string(from: givenNumber as NSNumber)!
    }
}
