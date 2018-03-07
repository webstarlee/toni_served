//
//  MakeOrderController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class MakeOrderController: UIViewController {

    @IBOutlet weak var makeOrderTextField: UITextView!
    
    @IBOutlet weak var tableNumberLabel: UILabel!
    
    @IBOutlet weak var Send_order_Button: UIButton!
    
    @IBOutlet weak var Circle_Button_image: UIImageView!
    
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        tableNumberLabel.text = Singletone.table_number
        makeOrderTextField.text = Singletone.current_order

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTO_Back(_ sender: Any) {
        
        Singletone.current_order = ""
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedRes = storyBoard.instantiateViewController(withIdentifier: "SelectedRes") as! SelectedResController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(selectedRes, animated: false)
        
    }
    
    @IBAction func goTo_SelectMenu(_ sender: Any) {
        
        Singletone.current_order = makeOrderTextField.text
        
        self.ref?.child("menu_food").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let res_info = snapshot.value as? [String:Any]
            
            if res_info != nil {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let selectMenu = storyBoard.instantiateViewController(withIdentifier: "SelectMenu") as! SelectMenuController
                self.navigationController?.pushViewController(selectMenu, animated: true)
                
            }
            else
            {
                let alertController = UIAlertController(title: "OBS", message: "DET ÄR INTE NÅGON MENY ÄN.", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(closeAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
            }
            
        })
        
    }
    
    @IBAction func changeCircleImage(_ sender: Any) {
        Circle_Button_image.image = UIImage(named: "circle_button_red")
    }
    
    @IBAction func Send_Order(_ sender: Any) {
        
        Circle_Button_image.image = UIImage(named: "circle_button")
        
        let alertController = UIAlertController(title: "SKICKA BESTÄLLNING?", message: "", preferredStyle: .alert)
        
        let alertController_warning = UIAlertController(title: "VARNA", message: "VÄLJ VÄLJ MAT FÖR BESTÄLLNING", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "JA", style: .default) { (action:UIAlertAction!) in
            
            Singletone.current_order = ""
            
            let current_restaurant_id = Singletone.restaurant_id as String
            let current_table_number = Singletone.table_number as String
            let order_body = self.makeOrderTextField.text as String
            
            //get current time
            let date = Date()
            let timestamp_hash = Int(Date().timeIntervalSince1970)
            let timestamp = String(timestamp_hash)
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            
            let current_date = String(components.year!) + "-" + String(components.month!) + "-" + String(components.day!) + " " + String(components.hour!) + ":" + String(components.minute!) + ":" + String(components.second!)
            
            let guest_deviceToken:AnyObject = Messaging.messaging().fcmToken as AnyObject
            let deviceUID = UIDevice.current.identifierForVendor?.uuidString
            
            self.ref?.child("res_order").child(current_restaurant_id).childByAutoId().setValue(["table_number": current_table_number,"order_body":order_body,"guest_uuid":deviceUID!,"guest_token":guest_deviceToken,"state":"sent","date": current_date,"timestamp": timestamp])
            
            print("aaaaa")
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let sentOrderController = storyBoard.instantiateViewController(withIdentifier: "SentOrder") as! SentOrderController
            
            self.navigationController?.pushViewController(sentOrderController, animated: true)
            
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
        if makeOrderTextField.text != ""
        {
            self.present(alertController, animated: true, completion:nil)
        }
        else
        {
            self.present(alertController_warning, animated: true, completion:nil)
        }
        
    }

}
