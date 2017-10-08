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
    @IBOutlet weak var tbState: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfQuotation.text = UserDefaults.standard.string(forKey: "quotation")
        tfIof.text = UserDefaults.standard.string(forKey: "iof")
    }

    @IBAction func AddState(_ sender: UIButton) {
        
    }
}
