//
//  ViewOneReservationController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewOneReservationController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var personalNumberLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var arriveTimeLabel: UILabel!
    
    @IBOutlet weak var guestNumberLabel: UILabel!
    
    @IBOutlet weak var reservationStateLabel: UILabel!
    
    @IBOutlet weak var reservationInfoView: RoundView!
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var currentReservationKey:String = "asdf"
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservationInfoView.isHidden = true
        loadingActivity.startAnimating()
        
        ref = Database.database().reference()
        
        ref?.child("res_reservation").child(Singletone.restaurant_id).child(currentReservationKey).observeSingleEvent(of: .value, with: { (snapshot_check) in
            let reservation_check = snapshot_check.value as? [String:Any]
            
            if reservation_check != nil
            {
                
                self.nameLabel.text = reservation_check?["name"] as? String
                self.personalNumberLabel.text = reservation_check?["personalNumber"] as? String
                self.phoneNumberLabel.text = reservation_check?["phoneNumber"] as? String
                self.arriveTimeLabel.text = reservation_check?["arriveTime"] as? String
                self.guestNumberLabel.text = reservation_check?["guestsNumber"] as? String
                
                let reservation_state = reservation_check?["state"] as? String
                
                if reservation_state == "sent"
                {
                    self.reservationStateLabel.text = "STATE : SENT"
                }
                else if reservation_state == "accept"
                {
                    self.reservationStateLabel.text = "STATE : ACCEPTED"
                }
                else if reservation_state == "reject"
                {
                    self.reservationStateLabel.text = "STATE : REJECTED"
                }

                
                self.reservationInfoView.isHidden = false
                UIView.transition(with: self.reservationInfoView,
                                  duration: 0.1,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
                self.loadingActivity.stopAnimating()
                
            }
            else
            {
                let alertController = UIAlertController(title: "MISSLYCKADES", message: "GICK NÅGOT FEL", preferredStyle: .alert)
                
                // Create Cancel button
                let cancelAction = UIAlertAction(title: "STÄNGA", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(cancelAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
                
                self.reservationInfoView.isHidden = false
                UIView.transition(with: self.reservationInfoView,
                                  duration: 0.1,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
                self.loadingActivity.stopAnimating()
            }
            
        })

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
