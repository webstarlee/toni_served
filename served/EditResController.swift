//
//  EditResController.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class EditResController: UIViewController {
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var beforeLodingActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var editInfoView: UIView!
    
    @IBOutlet weak var resNameField: PaddingTextField!
    
    @IBOutlet weak var resAddressField: PaddingTextField!
    
    @IBOutlet weak var resPhoneField: PaddingTextField!
    
    @IBOutlet weak var resDeiveNameField: PaddingTextField!
    
    @IBOutlet weak var resReservationTermField: UITextView!
    
    @IBOutlet weak var resReservationButton: UIButton!
    
    @IBOutlet weak var resStaffCallButton: UIButton!
    
    var reservationState:Bool = true
    
    var staffcallState:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beforeLodingActivity.startAnimating()
        
        editInfoView.isHidden = true
        
        ref = Database.database().reference()
        
        let restarantId = Singletone.restaurant_id
        
        self.ref?.child("res_list").child(restarantId).observeSingleEvent(of: .value, with: { (snapshot) in
            let res_info = snapshot.value as? [String:Any]
            
            self.resNameField.text = (res_info?["name"] as? String)?.uppercased()
            self.resAddressField.text = (res_info?["address"] as? String)?.uppercased()
            self.resPhoneField.text = (res_info?["phone_number"] as? String)?.uppercased()
            
            let devicename = (res_info?["device_name"] as? String)?.uppercased()
            if devicename == "NO DEVICE"
            {
                self.resDeiveNameField.text = ""
            }
            else
            {
                self.resDeiveNameField.text = devicename
            }
            
            let reservation_term = (res_info?["reservation_term"] as? String)?.uppercased()
            if reservation_term == "NO DATA"
            {
                self.resReservationTermField.text = ""
            }
            else
            {
                self.resReservationTermField.text = reservation_term
            }
            self.reservationState = (res_info?["reservation_check"] as? Bool)!
            
            if res_info?["reservation_check"] as? Bool == true
            {
                self.resReservationButton.setBackgroundImage(UIImage(named: "long_button"), for: .normal)
                self.resReservationButton.setTitle("AVAKTIVERA BORDSBOKNING", for: .normal)
            }
            else
            {
                self.resReservationButton.setBackgroundImage(UIImage(named: "long_button_red"), for: .normal)
                self.resReservationButton.setTitle("AKTIVERA BORDSBOKNING", for: .normal)
            }
            
            if res_info?["staffcall_check"] as? Bool == true
            {
                self.resStaffCallButton.setBackgroundImage(UIImage(named: "long_button"), for: .normal)
                self.resStaffCallButton.setTitle("AVAKTIVERA TILLKALLNING AV PERSONAL", for: .normal)
            }
            else
            {
                self.resStaffCallButton.setBackgroundImage(UIImage(named: "long_button_red"), for: .normal)
                self.resStaffCallButton.setTitle("AKTIVERA TILLKALLNING AV PERSONAL", for: .normal)
            }
            self.staffcallState = (res_info?["staffcall_check"] as? Bool)!
            
            self.editInfoView.isHidden = false
            UIView.transition(with: self.editInfoView,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            self.beforeLodingActivity.stopAnimating()
            
        })

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resMain = storyBoard.instantiateViewController(withIdentifier: "ResMain") as! ResMainController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        if resNameField.text != "", resAddressField.text != "", resPhoneField.text != ""
        {
            
            let restarantId = Singletone.restaurant_id
            let Set_Name = resNameField.text!
            let Set_Address = resAddressField.text!
            let Set_PhoneNumber = resPhoneField.text!
            let Reservation_Check = reservationState
            let StaffCall_Check = staffcallState
            var Set_DeviceName:String = ""
            
            if resDeiveNameField.text != ""
            {
                Set_DeviceName = resDeiveNameField.text!
            }
            else
            {
                Set_DeviceName = "No Device"
            }
            
            var Set_ReservationTerm:String = ""
            
            if resReservationTermField.text != ""
            {
                Set_ReservationTerm = resReservationTermField.text
            }
            else
            {
                Set_ReservationTerm = "No Data"
            }
            
            let deviceToken:AnyObject = Messaging.messaging().fcmToken as AnyObject
            
            self.ref?.child("res_list").child(restarantId).setValue(["name": Set_Name,"address": Set_Address,"phone_number": Set_PhoneNumber,"device_name": Set_DeviceName,"reservation_term": Set_ReservationTerm,"reservation_check":Reservation_Check,"staffcall_check":StaffCall_Check,"device_token": deviceToken])
            
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            
            self.navigationController?.pushViewController(resMain, animated: false)
            
        }else
        {
            let alertController = UIAlertController(title: "OBS", message: "SKRIV IN KORREKTA UPPGIFTER", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(closeAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
        }
        
    }
    
    @IBAction func reservationReset(_ sender: Any) {
        
        if reservationState == true {
            reservationState = false
            resReservationButton.setBackgroundImage(UIImage(named: "long_button_red"), for: .normal)
            resReservationButton.setTitle("ENABLE RESERVATION", for: .normal)
        }else
        {
            reservationState = true
            resReservationButton.setBackgroundImage(UIImage(named: "long_button"), for: .normal)
            resReservationButton.setTitle("DISABLE RESERVATION", for: .normal)
        }
    }
    
    @IBAction func staffcallReset(_ sender: Any) {
        
        if staffcallState == true {
            staffcallState = false
            resStaffCallButton.setBackgroundImage(UIImage(named: "long_button_red"), for: .normal)
            resStaffCallButton.setTitle("ENABLE STAFF CALLING", for: .normal)
        }else
        {
            staffcallState = true
            resStaffCallButton.setBackgroundImage(UIImage(named: "long_button"), for: .normal)
            resStaffCallButton.setTitle("DISABLE STAFF CALLING", for: .normal)
        }
    }
    
    @IBAction func Delete_Hosting(_ sender: Any) {
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let alertController = UIAlertController(title: "ÄR DU SÄKER ?", message: "VILL DU SLÄNGA DEN HÄR RESTAURANGEN ?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            self.ref?.child("res_list").child(Singletone.restaurant_id).setValue(nil)
            self.ref?.child("menu_kind").child(Singletone.restaurant_id).setValue(nil)
            self.ref?.child("menu_food").child(Singletone.restaurant_id).setValue(nil)
            // Code in this block will trigger when OK button tapped.
            
            Singletone.restaurant_id = ""
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let startController = storyBoard.instantiateViewController(withIdentifier: "startView") as! ViewController
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(startController, animated: false)
            
            
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
