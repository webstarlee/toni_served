//
//  SetTableNumberController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit

protocol SetTableNumberDelegate: class {
    func goTo_selectedRes()
}

class SetTableNumberController: UIViewController {

    weak var delegate : SetTableNumberDelegate?
    
    @IBOutlet weak var tableNumberTextField: RoundTextFiled!
    
    var forSetResId:String?
    var forSetCheckReservation:String?
    var forSetCheckStaffCall:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(forSetResId!)
        print(forSetCheckReservation!)
        print(forSetCheckStaffCall!)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forOrder(_ sender: Any) {
        
        if tableNumberTextField.text != ""
        {
            Singletone.guest_type = "order"
            Singletone.table_number = tableNumberTextField.text!
            Singletone.restaurant_id = forSetResId!
            Singletone.check_reservation_enable = forSetCheckReservation!
            Singletone.check_staffcall_enable = forSetCheckStaffCall!
            Singletone.current_order = ""
            
            self.dismiss(animated: true) {
                self.delegate?.goTo_selectedRes()
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
    
    @IBAction func forReservation(_ sender: Any) {
        
        Singletone.guest_type = "reservation"
        Singletone.restaurant_id = forSetResId!
        Singletone.check_reservation_enable = forSetCheckReservation!
        Singletone.check_staffcall_enable = forSetCheckStaffCall!
        Singletone.current_order = ""
        
        self.dismiss(animated: true) {
            self.delegate?.goTo_selectedRes()
        }
        
    }

}
