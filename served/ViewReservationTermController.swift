//
//  ViewReservationTermController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewReservationTermController: UIViewController {

    @IBOutlet weak var reservationTextView: UITextView!
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingActivity.startAnimating()
        reservationTextView.isHidden = true
        
        ref = Database.database().reference()
        
        self.ref?.child("res_list").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let res_info = snapshot.value as? [String:Any]
            self.reservationTextView.text = res_info?["reservation_term"] as? String
            
            self.reservationTextView.isHidden = false
            self.loadingActivity.stopAnimating()
            
        })

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
