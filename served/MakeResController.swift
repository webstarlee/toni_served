//
//  MakeResController.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class MakeResController: UIViewController {

    @IBOutlet weak var resName: PaddingTextField!
    
    @IBOutlet weak var resAddress: PaddingTextField!
    
    @IBOutlet weak var resPhone: PaddingTextField!
    
    @IBOutlet weak var resDevice: PaddingTextField!
    
    @IBOutlet weak var resReservationTerm: UITextView!
    
    @IBOutlet weak var reservationButton: UIButton!
    
    @IBOutlet weak var staffcallButton: UIButton!
    
    var reservationState:Bool = true
    
    var staffcallState:Bool = true
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_back(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let hostLogin = storyBoard.instantiateViewController(withIdentifier: "hostLogin") as! HostLoginController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(hostLogin, animated: false)
    }
    
    @IBAction func reservationReset(_ sender: Any) {
        
        if reservationState == true {
            reservationState = false
            reservationButton.setBackgroundImage(UIImage(named: "long_button_red"), for: .normal)
            reservationButton.setTitle("AKTIVERA BORDSBOKNING ", for: .normal)
        }else
        {
            reservationState = true
            reservationButton.setBackgroundImage(UIImage(named: "long_button"), for: .normal)
            reservationButton.setTitle("AVAKTIVERA BORDSBOKNING", for: .normal)
        }
        
    }
    
    @IBAction func staffcallReset(_ sender: Any) {
        
        if staffcallState == true {
            staffcallState = false
            staffcallButton.setBackgroundImage(UIImage(named: "long_button_red"), for: .normal)
            staffcallButton.setTitle("AKTIVERA TILLKALLNING AV PERSONAL", for: .normal)
        }else
        {
            staffcallState = true
            staffcallButton.setBackgroundImage(UIImage(named: "long_button"), for: .normal)
            staffcallButton.setTitle("AVAKTIVERA TILLKALLNING AV PERSONAL", for: .normal)
        }
    }
    
    @IBAction func createRestaurant(_ sender: Any) {
        
        if resName.text != "", resAddress.text != "", resPhone.text != ""
        {
            
            let restarantId = Singletone.restaurant_id
            let Set_Name = resName.text!
            let Set_Address = resAddress.text!
            let Set_PhoneNumber = resPhone.text!
            let Reservation_Check = reservationState
            let StaffCall_Check = staffcallState
            var Set_DeviceName:String = ""
            
            if resDevice.text != ""
            {
                Set_DeviceName = resDevice.text!
            }
            else
            {
                Set_DeviceName = "NO DEVICE"
            }
            
            var Set_ReservationTerm:String = ""
            
            if resReservationTerm.text != ""
            {
                Set_ReservationTerm = resReservationTerm.text
            }
            else
            {
                Set_ReservationTerm = "NO DATA"
            }
            
            let deviceToken:AnyObject = Messaging.messaging().fcmToken as AnyObject
            
            self.ref?.child("res_list").child(restarantId).setValue(["name": Set_Name,"address": Set_Address,"phone_number": Set_PhoneNumber,"device_name": Set_DeviceName,"reservation_term": Set_ReservationTerm,"reservation_check":Reservation_Check,"staffcall_check":StaffCall_Check,"device_token": deviceToken])
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let resMain = storyBoard.instantiateViewController(withIdentifier: "ResMain") as! ResMainController
            
            self.navigationController?.pushViewController(resMain, animated: true)
            
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
    

}
