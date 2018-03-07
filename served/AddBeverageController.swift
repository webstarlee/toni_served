//
//  AddBeverageController.swift
//  served
//
//  Created by firebase on 10/9/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol AddBeverageDelegate: class {
    func addedNewBeverage()
}

class AddBeverageController: UIViewController {

    weak var delegate : AddBeverageDelegate?
    
    @IBOutlet weak var beverage_name_text: PaddingTextField!
    
    @IBOutlet weak var beverage_material_text: PaddingTextField!
    
    @IBOutlet weak var beverage_price_text: PaddingTextField!
    
    var beverage_Kind_Name : String = ""
    
    var beverage_Kind_Key : String = ""
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Add_Food(_ sender: Any) {
        
        if beverage_name_text.text != "" , beverage_price_text.text != ""
        {
            
            
            self.ref?.child("menu_beverage").child(Singletone.restaurant_id).child(self.beverage_Kind_Key).childByAutoId().setValue(["name": beverage_name_text.text, "material":beverage_material_text.text, "price": beverage_price_text.text])
            
            self.dismiss(animated: true) {
                self.delegate?.addedNewBeverage()
            }
        }
        else
        {
            let alertController = UIAlertController(title: "OBS", message: "SKRIV IN KORREKTA UPPGIFTER", preferredStyle: .alert)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
        }
    }

}
