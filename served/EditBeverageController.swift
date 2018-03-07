//
//  EditBeverageController.swift
//  served
//
//  Created by firebase on 10/9/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol EditBeverageDelegate: class {
    func addedNewBeverage()
}

class EditBeverageController: UIViewController {

    weak var delegate : EditBeverageDelegate?
    
    
    @IBOutlet weak var beverage_name_text: PaddingTextField!
    
    @IBOutlet weak var beverage_material_text: PaddingTextField!
    
    @IBOutlet weak var beverage_price_text: PaddingTextField!
    
    var set_beverage_name: String = ""
    
    var set_beverage_material: String = ""
    
    var set_beverage_price: String = ""
    
    var set_beverage_kind_key: String = ""
    
    var set_beverage_key: String = ""
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        beverage_name_text.text = set_beverage_name.uppercased()
        beverage_material_text.text = set_beverage_material.uppercased()
        beverage_price_text.text = set_beverage_price

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Edit_Food(_ sender: Any) {
        if beverage_name_text.text != "" && beverage_material_text.text != "" && beverage_price_text.text != ""
        {
            
            self.ref?.child("menu_beverage").child(Singletone.restaurant_id).child(self.set_beverage_kind_key).child(self.set_beverage_key).setValue(["name": beverage_name_text.text, "material":beverage_material_text.text, "price": beverage_price_text.text])
            
            self.dismiss(animated: true) {
                self.delegate?.addedNewBeverage()
            }
        }
    }
    
    @IBAction func Delete_Food(_ sender: Any) {
        
        let alertController = UIAlertController(title: "ÄR DU SÄKER?", message: "VILL DU SLÄNGA BORT DETTA LIVSMEDEL ?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            
            self.ref?.child("menu_beverage").child(Singletone.restaurant_id).child(self.set_beverage_kind_key).child(self.set_beverage_key).setValue(nil)
            
            self.dismiss(animated: true) {
                self.delegate?.addedNewBeverage()
            }
            
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "ANNULLERA", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
    }


}
