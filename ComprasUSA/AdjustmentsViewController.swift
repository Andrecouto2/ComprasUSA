//
//  AdjustmentsViewController.swift
//  ComprasUSA
//
//  Created by André Couto on 30/09/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import UIKit

class AdjustmentsViewController: UIViewController {

    @IBOutlet weak var tfQuotation: UITextField!
    @IBOutlet weak var tfIof: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfQuotation.text = UserDefaults.standard.string(forKey: "quotation")
        tfIof.text = UserDefaults.standard.string(forKey: "iof")
    }

}
