//
//  MakeReservationController.swift
//  served
//
//  Created by firebase on 10/9/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class MakeReservationController: UIViewController {

    @IBOutlet weak var makeName: PaddingTextField!
    
    @IBOutlet weak var personalNumber: PaddingTextField!
    
    @IBOutlet weak var phoneNumber: PaddingTextField!
    
    @IBOutlet weak var arriveDateTime: PaddingTextField!
    
    @IBOutlet weak var guestNumber: PaddingTextField!
    
    @IBOutlet weak var Send_order_Button: UIButton!
    
    @IBOutlet weak var viewReservationButton: UIButton!
    
    @IBOutlet weak var Circle_Button_image: UIImageView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if Singletone.reservationTextCheck == "NO DATA"
        {
            viewReservationButton.isEnabled = false
        }

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_back(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectReservationType = storyBoard.instantiateViewController(withIdentifier: "SelectReservationType") as! SelectReservationTypeController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(selectReservationType, animated: false)
        
    }
    
    @IBAction func dateTimeEditing(_ sender: PaddingTextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        arriveDateTime.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func changeCircleImage(_ sender: Any) {
        
        Circle_Button_image.image = UIImage(named: "circle_button_red")
        
    }
    
    @IBAction func SendReservation(_ sender: Any) {
        
        Circle_Button_image.image = UIImage(named: "circle_button")
        
        let alertController = UIAlertController(title: "SKICKA FÖRFRÅGAN?", message: "", preferredStyle: .alert)
        
        let alertController_warning = UIAlertController(title: "OBS", message: "SKRIV IN KORREKTA UPPGIFTER", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "JA", style: .default) { (action:UIAlertAction!) in
            
            let ownName = self.makeName.text!
            let perNumber = self.personalNumber.text!
            let phone = self.phoneNumber.text!
            let atTime = self.arriveDateTime.text!
            let allGuests = self.guestNumber.text!
            let timestamp_hash = Int(Date().timeIntervalSince1970)
            let timestamp = String(timestamp_hash)
            
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            
            let current_date = String(components.year!) + "-" + String(components.month!) + "-" + String(components.day!) + " " + String(components.hour!) + ":" + String(components.minute!) + ":" + String(components.second!)
            let guest_deviceToken:AnyObject = Messaging.messaging().fcmToken as AnyObject
            
            let deviceUID = UIDevice.current.identifierForVendor?.uuidString
            
            self.ref?.child("res_reservation").child(Singletone.restaurant_id).childByAutoId().setValue(["name": ownName, "personalNumber":perNumber, "phoneNumber":phone, "guestsNumber":allGuests,"guest_uuid":deviceUID!,"guest_token":guest_deviceToken,"state":"sent","arriveTime": atTime, "makeTime":current_date,"timestamp": timestamp])
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let sentReservationController = storyBoard.instantiateViewController(withIdentifier: "SentReservation") as! SentReservationController
            
            self.navigationController?.pushViewController(sentReservationController, animated: true)
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "NEJ", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController.addAction(cancelAction)
        
        
        let closeAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController_warning.addAction(closeAction)
        
        // Present Dialog message
        if makeName.text != "" , personalNumber.text != "" , phoneNumber.text != "" , arriveDateTime.text != "" , guestNumber.text != ""
        {
            self.present(alertController, animated: true, completion:nil)
        }
        else
        {
            self.present(alertController_warning, animated: true, completion:nil)
        }
        
    }

}
