//
//  HostCompleteReservationController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HostCompleteReservationController: UIViewController {

    @IBOutlet weak var select_serve_type: UISegmentedControl!
    
    @IBOutlet weak var accept_segmented_label: UILabel!
    
    @IBOutlet weak var reject_segmented_label: UILabel!
    
    @IBOutlet weak var reservationerName: UILabel!
    
    @IBOutlet weak var reservationerPersonalNumber: UILabel!
    
    @IBOutlet weak var reservationerPhoneNumber: UILabel!
    
    @IBOutlet weak var reservationerArriveTime: UILabel!
    
    @IBOutlet weak var reservationerGuestsNumber: UILabel!
    
    var settingName:String = ""
    
    var settingPersonalNumber:String = ""
    
    var settingPhoneNumber:String = ""
    
    var settingArriveTime:String = ""
    
    var settingGuestsNumber:String = ""
    
    var reservationKey: String = ""
    
    var serveType : String = "ACCEPT"
    var sendserve_type : String = "accept"
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        reservationerName.text = "NAMN: " + settingName.uppercased()
        
        reservationerPersonalNumber.text = "PERSONNUMMER: " + settingPersonalNumber
        
        reservationerPhoneNumber.text = "TELEFONNUMMER: " + settingPhoneNumber
        
        reservationerArriveTime.text = "TID VID ANKOMST: " + settingArriveTime
        
        reservationerGuestsNumber.text = "ANTAL PERSONER: " + settingGuestsNumber

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func change_Serve_Type(_ sender: UISegmentedControl) {
        
        switch select_serve_type.selectedSegmentIndex {
        case 0:
            accept_segmented_label.textColor = UIColor.white
            reject_segmented_label.textColor = UIColor.black
            serveType = "ACCEPT"
            sendserve_type = "accept"
            
            self.sent_reservation_serve()
        case 1:
            accept_segmented_label.textColor = UIColor.black
            reject_segmented_label.textColor = UIColor.white
            serveType = "REJECT"
            sendserve_type = "reject"
            
            self.sent_reservation_serve()
        default:
            break
        }
    }
    
    @IBAction func Go_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sent_reservation_serve(){
        
        let alertController = UIAlertController(title: "ACCEPTERA BORDSBOKNING?", message: "VILL DU "  + serveType + " DENNA RESERVERING ?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "JA", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            
            self.ref?.child("res_reservation").child(Singletone.restaurant_id).child(self.reservationKey).child("state").setValue(self.sendserve_type)
            
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromLeft
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let  hostReservationView = storyBoard.instantiateViewController(withIdentifier: "HostReservationView") as! HostReservationViewController
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(hostReservationView, animated: false)
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "NEJ", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
    }

}
