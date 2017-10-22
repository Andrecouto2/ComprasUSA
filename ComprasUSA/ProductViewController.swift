//
//  ProductViewController.swift
//  ComprasUSA
//
//  Created by André Couto on 30/09/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var btAddState: UIButton!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btSaveProduct: UIButton!
    
    var pickerView: UIPickerView!
    var dataSource: [State] = []
    
    // MARK: - Properties
    var smallImage: UIImage!
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if product != nil {
            tfName.text = product.name
            tfValue.text = product.value.getCurrencyInputFormat(currencySymbol: "US$")
            swCard.setOn(product.isBoughtByCard , animated: false)
            
            if let image = product.photo as? UIImage {
                ivProduct.image = image
            }
            
            btSaveProduct.setTitle("SALVAR", for: .normal)
        }
        
        tfName.addTarget(self, action: #selector(self.validateTextField(_:)), for: .editingChanged)
        tfValue.addTarget(self, action: #selector(self.formatCurrencyValue(_:)), for: .editingChanged)
        tfValue.addTarget(self, action: #selector(self.validateTextField(_:)), for: .editingChanged)
        tfState.addTarget(self, action: #selector(self.validateTextField(_:)), for: .editingChanged)
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
   
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(finish))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.items = [btCancel, btSpace, btDone]

        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if product != nil {
            if let state = product.states {
                tfState.text = state.name!
            }
        }
        
        loadStates()
        validateForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        purgeUnsavedChanges()
    }
    
    func purgeUnsavedChanges() {
        if product != nil {
            
            // Remove o produto caso ele não esteja persistido e a view esteja sofrendo pop
            // Reverte as alterações não salvas do produto previamente persistido
            if product.objectID.isTemporaryID && isMovingFromParentViewController {
                context.delete(product)
                product = nil
            } else if !product.objectID.isTemporaryID {
                context.refresh(product, mergeChanges: false)
            }
        }
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func done() {
        if !dataSource.isEmpty {
            tfState.text = dataSource[pickerView.selectedRow(inComponent: 0)].name
        }
        
        validateForm()
        finish()
    }
    
    func finish() {
        tfState.resignFirstResponder()
    }

    @IBAction func setProductImageView(_ sender: UIButton) {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar imagem do produto", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveProduct(_ sender: UIButton) {
        guard   let name = tfName.text,
                let valueString = tfValue.text,
                let value = Double(valueString.removeCurrencyInputFormat()),
                let state = getStateFromTextField() else {
            return
        }
        
        if product == nil {
            product = Product(context: context)
        }
        
        product.name = name
        product.value = value
        product.isBoughtByCard = swCard.isOn
        product.states = state
        
        print("\(pickerView.selectedRow(inComponent: 0))")
        print("\(dataSource[pickerView.selectedRow(inComponent: 0)])")
        
        if smallImage != nil {
            product.photo = smallImage
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        purgeUnsavedChanges()
        navigationController?.popViewController(animated:true)
    }
   
    // MARK:  Methods
    func getStateFromTextField() -> State? {
        if let stateNameInTextField = tfState.text {
            for state in dataSource {
                if state.name == stateNameInTextField {
                    return state
                }
            }
        }
        
        return nil
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func formatCurrencyValue(_ sender: UITextField) {
        if let formattedValue = sender.text?.addCurrencyInputFormat(currencySymbol: "US$") {
            sender.text = formattedValue
        }
    }
    
    func validateTextField(_ sender: UITextField) {
        validateForm()
    }
    
    func validateForm() {
        var isFormValid = true;
        
        if let name = tfName.text, name.isEmpty {
            if name.isEmpty {
                isFormValid = false;
            }
        }
        if let state = tfState.text {
            if state.isEmpty || getStateFromTextField() == nil {
                isFormValid = false;
            }
        }
        if let value = tfValue.text {
            if value.isEmpty || Double(value.removeCurrencyInputFormat()) == nil {
                isFormValid = false
            }
        }
        
        enableSaveButton(isFormValid)
    }
    
    func enableSaveButton(_ enabled: Bool) {
        
        btSaveProduct.isEnabled = enabled
        
        if btSaveProduct.isEnabled {
            btSaveProduct.alpha = 1.0
        } else {
            btSaveProduct.alpha = 0.5
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for txt in self.view.subviews {
            if txt.isKind(of: UITextField.self) && txt.isFirstResponder {
                txt.resignFirstResponder()
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ivProduct.image = smallImage
        dismiss(animated: true, completion: nil)
    }
}

extension ProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return dataSource[row].name
    }
}

extension ProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Usaremos apenas 1 coluna (component) em nosso pickerView
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count //O total de linhas será o total de itens em nosso dataSource
    }
}
