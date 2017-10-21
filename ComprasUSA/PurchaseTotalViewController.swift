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
        var totalUSD: Double = 0
        var totalBRL: Double = 0
        
        for product in dataSource {
            guard let productValueBRL = product.valueBRL else {
                lbTotalDollar.text = "-"
                lbTotalReal.text = "-"
                
                showErrorAlert()
                return
            }
            
            totalUSD += product.value
            totalBRL += productValueBRL
        }
        
        lbTotalDollar.text = totalUSD.getCurrencyInputFormat(currencySymbol: "")
        lbTotalReal.text = totalBRL.getCurrencyInputFormat(currencySymbol: "")
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "Atenção", message: "Verifique na tela de ajustes se o IOF e a Cotação do Dólar estão preenchidos corretamente", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
