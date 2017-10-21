//
//  PurchaseTotalViewController.swift
//  ComprasUSA
//
//  Created by André Couto on 30/09/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import UIKit
import CoreData

class PurchaseTotalViewController: UIViewController {

    @IBOutlet weak var lbTotalDollar: UILabel!
    
    @IBOutlet weak var lbTotalReal: UILabel!
    
    var dataSource:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts()
        calculate()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

    func calculate() {
        
        var grossValue: Double = 0
        var dollarWithImpost: Double = 0
        
        for product in dataSource {
            grossValue = grossValue + product.value
            if product.isBoughtByCard {
                dollarWithImpost = dollarWithImpost + (product.value + ((product.value * (product.states?.tax)!)/100))
            } else {
                dollarWithImpost = dollarWithImpost + product.value
            }
        }
        
        lbTotalDollar.text = grossValue.getCurrencyInputFormat(currencySymbol: "")
        
        var realQuotation: Double = 0
        
        realQuotation = (dollarWithImpost * Double(UserDefaults.standard.string(forKey: "quotation")!)!)
        
        var realIof: Double = 0
        
        realIof = (realQuotation + ((realQuotation * Double(UserDefaults.standard.string(forKey: "iof")!)!)/100))
        
        lbTotalReal.text = realIof.getCurrencyInputFormat(currencySymbol: "")
    }

}
