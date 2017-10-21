//
//  AdjustmentsViewController.swift
//  ComprasUSA
//
//  Created by André Couto on 30/09/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import UIKit
import CoreData

enum StateType {
    case add
    case edit
}

class AdjustmentsViewController: UIViewController {

    @IBOutlet weak var tfQuotation: UITextField!
    @IBOutlet weak var tfIof: UITextField!
    @IBOutlet weak var tbState: UITableView!
    
    // MARK: - Properties
    var dataSource: [State] = []
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    weak var alertSaveStateAction: UIAlertAction?
    weak var alertStateNameTextField: UITextField?
    weak var alertStateTaxTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfQuotation.tag = 1
        tfIof.tag = 2
        tfQuotation.delegate = self
        tfIof.delegate = self
        
        tbState.estimatedRowHeight = 106
        tbState.rowHeight = UITableViewAutomaticDimension
        tbState.tableFooterView = UIView()
        tbState.delegate = self
        tbState.dataSource = self
        
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.textColor = .black
        
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfQuotation.text = UserDefaults.standard.string(forKey: "quotation")
        tfIof.text = UserDefaults.standard.string(forKey: "iof")
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tbState.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func AddState(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
    
    func showAlert(type: StateType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            textField.addTarget(self, action: #selector(self.alertTextFieldTextChanged(_:)), for: .editingChanged)
            
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Taxa do estado"
            textField.keyboardType = .decimalPad
            textField.addTarget(self, action: #selector(self.alertTextFieldTextChanged(_:)), for: .editingChanged)
            
            if let tax = state?.tax {
                textField.text = String(tax)
            }
        }
        
        let saveStateAction = UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            guard   let name = alert.textFields?[0].text,
                    let tax = alert.textFields?[1].text, (Double(tax) != nil)
            else {
                return
            }
            
            let state = state ?? State(context: self.context)
            state.name = name
            state.tax = Double(tax)!
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        })
        
        saveStateAction.isEnabled = false
        
        self.alertStateNameTextField = alert.textFields?[0]
        self.alertStateTaxTextField = alert.textFields?[1]
        self.alertSaveStateAction = saveStateAction
        
        alert.addAction(saveStateAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertTextFieldTextChanged(_ sender: UITextField) {
        guard   let name = alertStateNameTextField?.text,
                let tax = alertStateTaxTextField?.text
        else {
            alertSaveStateAction?.isEnabled = false
            return
        }
        
        if name.isEmpty || tax.isEmpty || Double(tax) == nil {
            alertSaveStateAction?.isEnabled = false
            return
        }
        
        alertSaveStateAction?.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for txt in self.view.subviews {
            if txt.isKind(of: UITextField.self) && txt.isFirstResponder {
                txt.resignFirstResponder()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension AdjustmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            
            self.showAlert(type: .edit, state: state)
        }
        
        editAction.backgroundColor = .blue
        
        return [editAction, deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let count = try! context.fetch(fetchRequest).count
        
        if count > 0 {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let state = dataSource[indexPath.row]
        
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = String(state.tax)
        cell.detailTextLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = self.dataSource[indexPath.row]
        tableView.setEditing(false, animated: true)
        
        self.showAlert(type: .edit, state: state)
    }
}

extension AdjustmentsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        switch textField.tag {
        case 1:
            UserDefaults.standard.set(tfQuotation.text!, forKey: "quotation")
        case 2:
            UserDefaults.standard.set(tfIof.text!, forKey: "iof")
        default: break
        }
    }
}
