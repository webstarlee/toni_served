//
//  ResMainController.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ResMainController: UIViewController {

    var ref:DatabaseReference?
    
    @IBOutlet weak var resNameLabel: UILabel!
    
    @IBOutlet weak var resDeviceLabel: UILabel!
    
    @IBOutlet weak var resPhoneLabel: UILabel!
    
    @IBOutlet weak var resInfoView: UIView!
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBOutlet weak var orderBadgeImage: UIImageView!
    
    @IBOutlet weak var reservationNumberLabel: UILabel!
    
    @IBOutlet weak var reservationBadgeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resInfoView.isHidden = true

        ref = Database.database().reference()
        
        let restarantId = Singletone.restaurant_id
        
        self.ref?.child("res_list").child(restarantId).observeSingleEvent(of: .value, with: { (snapshot_list) in
            let res_list = snapshot_list.value as? [String: Any]
            if res_list != nil
            {
                let res_name = res_list?["name"] as? String
                let res_address = res_list?["address"] as? String
                let res_phone = res_list?["phone_number"] as? String
                
                self.resNameLabel.text = res_name
                self.resDeviceLabel.text = res_address
                self.resPhoneLabel.text = res_phone
            }
            
            self.resInfoView.isHidden = false
            UIView.transition(with: self.resInfoView,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            
        })
        
        self.ref?.child("res_order").child(restarantId).observeSingleEvent(of: .value, with: { (snapshot_list) in
            let order_list = snapshot_list.value as? [String: Any]
            if order_list != nil
            {
                var orderNumber : Int = 0
                
                for (_ , val) in order_list! {
                    
                    let order_info = val as? [String: Any]
                    
                    let order_state = order_info?["state"] as? String
                    
                    if order_state == "sent"
                    {
                        orderNumber += 1
                    }
                }
                
                if orderNumber > 0
                {
                    self.orderNumberLabel.text = String(orderNumber)
                    self.orderNumberLabel.isHidden = false
                    self.orderBadgeImage.isHidden = false
                }
                
            }
        })
        
        self.ref?.child("res_reservation").child(restarantId).observeSingleEvent(of: .value, with: { (snapshot_list) in
            let reservation_list = snapshot_list.value as? [String: Any]
            if reservation_list != nil
            {
                var reservationNumber : Int = 0
                
                for (_ , val) in reservation_list! {
                    
                    let reservation_info = val as? [String: Any]
                    
                    let reservation_state = reservation_info?["state"] as? String
                    
                    if reservation_state == "sent"
                    {
                        reservationNumber += 1
                    }
                }
                
                if reservationNumber > 0
                {
                    self.reservationNumberLabel.text = String(reservationNumber)
                    self.reservationNumberLabel.isHidden = false
                    self.reservationBadgeImage.isHidden = false
                }
                
            }
        })
        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
        Singletone.restaurant_id = ""
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let startController = storyBoard.instantiateViewController(withIdentifier: "startView") as! ViewController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(startController, animated: false)
        
    }
    
    @IBAction func editRes(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editRes = storyBoard.instantiateViewController(withIdentifier: "EditRes") as! EditResController
        self.navigationController?.pushViewController(editRes, animated: true)
    }
    
    @IBAction func menuMake(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuMake = storyBoard.instantiateViewController(withIdentifier: "MenuMake") as! MenuMakeController
        self.navigationController?.pushViewController(menuMake, animated: true)
        
    }

}
