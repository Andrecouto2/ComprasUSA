//
//  ProductViewController.swift
//  ComprasUSA
//
//  Created by André Couto on 30/09/17.
//  Copyright © 2017 André Couto. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var btAddState: UIButton!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    
    // MARK: - Properties
    var smallImage: UIImage!
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if product == nil {
            product = Product(context: context)
        }
        //let vc = segue.destination as! StateViewController
        //vc.product = product
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func setProductImageView(_ sender: UIButton) {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar imagem do produto", message: "De onde você quer escolher a imagem ?", preferredStyle: .actionSheet)
        
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
    
    // MARK:  Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
