//
//  String+CurrencyInputFormat.swift
//  ComprasUSA
//
//  Created by Matheus Coelho Espinasso on 19/10/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import Foundation

extension String {
    
    func addCurrencyInputFormat(currencySymbol: String) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var givenString = self
        
        // Keep only numbers in the String
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        givenString = regex.stringByReplacingMatches(in: givenString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let givenNumber = (givenString as NSString).doubleValue
        let ajustedNumber = NSNumber(value: (givenNumber / 100))
        
        // Returns an empty String if the ajustedNumber is 0 or all numbers were deleted
        guard ajustedNumber != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: ajustedNumber)!
    }
    
    func removeCurrencyInputFormat() -> String {
        
        var givenString = self
        
        // Keep only numbers in the String
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        givenString = regex.stringByReplacingMatches(in: givenString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let givenNumber = (givenString as NSString).doubleValue
        let ajustedNumber = NSNumber(value: (givenNumber / 100))
        
        // Returns an empty String if the ajustedNumber is 0 or all numbers were deleted
        guard ajustedNumber != 0 as NSNumber else {
            return ""
        }
        
        return ajustedNumber.stringValue
    }
}
