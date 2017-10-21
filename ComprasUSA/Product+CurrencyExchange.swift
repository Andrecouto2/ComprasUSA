//
//  Product+CurrencyExchange.swift
//  ComprasUSA
//
//  Created by Matheus Coelho Espinasso on 21/10/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import Foundation

extension Product {
    
    var valueBRL: Double? {
        guard   let iofTaxValue = Double(UserDefaults.standard.string(forKey: "iof")!),
                let usdQuotation = Double(UserDefaults.standard.string(forKey: "quotation")!),
                let states = self.states
            else {
                return nil
        }
        
        var productValueBRL = self.value * ((states.tax / 100) + 1)
        productValueBRL *= usdQuotation
        
        if self.isBoughtByCard {
            productValueBRL *= (iofTaxValue / 100) + 1
        }
        
        return productValueBRL
    }
}
