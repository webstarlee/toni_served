//
//  AddFoodKindController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol AddKindDelegate: class {
    func addedNewFood()
}

class AddFoodKindController: UIViewController {

    weak var delegate : AddKindDelegate?
    
    @IBOutlet weak var food_kind_text: PaddingTextField!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Add_Kind(_ sender: Any) {
        
        if food_kind_text.text != ""
        {
            let restarantId = Singletone.restaurant_id
            
            self.ref?.child("menu_kind").child(restarantId).childByAutoId().setValue(food_kind_text.text)
            
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
