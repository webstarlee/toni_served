//
//  AddFoodController.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol AddFoodDelegate: class {
    func addedNewFood()
}

class AddFoodController: UIViewController {

    weak var delegate : AddFoodDelegate?
    
    @IBOutlet weak var food_name_text: PaddingTextField!
    
    @IBOutlet weak var food_material_text: PaddingTextField!
    
    @IBOutlet weak var food_price_text: PaddingTextField!
    
    var Food_Kind_Name : String = ""
    
    var Food_Kind_Key : String = ""
    
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
        
        if food_name_text.text != "" , food_price_text.text != ""
        {
            
            
            self.ref?.child("menu_food").child(Singletone.restaurant_id).child(self.Food_Kind_Key).childByAutoId().setValue(["name": food_name_text.text, "material":food_material_text.text, "price": food_price_text.text])
            
            self.dismiss(animated: true) {
                self.delegate?.addedNewFood()
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
