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
        guard   let iofTaxString = UserDefaults.standard.string(forKey: "iof"),
                let iofTaxValue = iofTaxString.doubleValue,
                let usdQuotationString = UserDefaults.standard.string(forKey: "quotation"),
                let usdQuotationValue = usdQuotationString.doubleValue,
                let states = self.states
            else {
                return nil
        }
        
        var productValueBRL = self.value * ((states.tax / 100) + 1)
        productValueBRL *= usdQuotationValue
        
        if self.isBoughtByCard {
            productValueBRL *= (iofTaxValue / 100) + 1
        }
        
        return productValueBRL
    }
}
