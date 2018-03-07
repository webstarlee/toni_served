//
//  EditFoodController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol EditFoodDelegate: class {
    func addedNewFood()
}

class EditFoodController: UIViewController {

    weak var delegate : EditFoodDelegate?
    
    @IBOutlet weak var food_kind_label: UILabel!
    
    @IBOutlet weak var food_name_text: PaddingTextField!
    
    @IBOutlet weak var food_material_text: PaddingTextField!
    
    @IBOutlet weak var food_price_text: PaddingTextField!
    
    var set_food_kind: String = ""
    
    var set_food_name: String = ""
    
    var set_food_material: String = ""
    
    var set_food_price: String = ""
    
    var set_food_kind_key: String = ""
    
    var set_food_key: String = ""
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        food_kind_label.text = set_food_kind.uppercased()
        food_name_text.text = set_food_name.uppercased()
        food_material_text.text = set_food_material.uppercased()
        food_price_text.text = set_food_price

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Edit_Food(_ sender: Any) {
        if food_name_text.text != "" && food_material_text.text != "" && food_price_text.text != ""
        {
            var auto_restarantId:String = ""
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                auto_restarantId = uuid
            }
            
            self.ref?.child("menu_food").child(auto_restarantId).child(self.set_food_kind_key).child(self.set_food_key).setValue(["name": food_name_text.text, "material":food_material_text.text, "price": food_price_text.text])
            
            self.dismiss(animated: true) {
                self.delegate?.addedNewFood()
            }
        }
    }
    
    @IBAction func Delete_Food(_ sender: Any) {
        
        let alertController = UIAlertController(title: "ÄR DU SÄKER?", message: "VILL DU SLÄNGA BORT DETTA LIVSMEDEL ?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            
            var auto_restarantId:String = ""
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                auto_restarantId = uuid
            }
            
            self.ref?.child("menu_food").child(auto_restarantId).child(self.set_food_kind_key).child(self.set_food_key).setValue(nil)
            
            self.dismiss(animated: true) {
                self.delegate?.addedNewFood()
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
