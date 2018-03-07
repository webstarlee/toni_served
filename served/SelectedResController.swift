//
//  SelectedResController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class SelectedResController: UIViewController {

    @IBOutlet weak var Restaurant_Name: UILabel!
    
    @IBOutlet weak var Restaurant_Address: UILabel!
    
    @IBOutlet weak var Restaurant_Phone: UILabel!
    
    @IBOutlet weak var placeOrderButton: UIButton!
    
    @IBOutlet weak var currentOrderButton: UIButton!
    
    @IBOutlet weak var Make_Reservation_Button: UIButton!
    
    @IBOutlet weak var Staff_Call_Button: UIButton!
    
    @IBOutlet weak var Circle_button_image: UIImageView!
    
    @IBOutlet weak var Staff_call_embeded_View: UIView!
    
    @IBOutlet weak var Circle_Image: UIImageView!
    
    @IBOutlet weak var resInfoView: UIView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resInfoView.isHidden = true
        
        if Singletone.guest_type == "reservation"
        {
            placeOrderButton.isEnabled = false
            currentOrderButton.isEnabled = false
        }
        
        if Singletone.check_staffcall_enable == "false" || Singletone.guest_type == "reservation"
        {
            Staff_call_embeded_View.isHidden = true
        }
        
        if Singletone.check_reservation_enable == "false"
        {
            Make_Reservation_Button.isEnabled = false
        }
        
        ref = Database.database().reference()
        
        self.ref?.child("res_list").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let res_info = snapshot.value as? [String:Any]
            self.Restaurant_Name.text = res_info?["name"] as? String
            self.Restaurant_Address.text = res_info?["address"] as? String
            self.Restaurant_Phone.text = res_info?["phone_number"] as? String
            
            let checkReservationString = res_info?["reservation_term"] as? String
            
            if checkReservationString == "" || checkReservationString == "NO DATA"
            {
                Singletone.reservationTextCheck = "NO DATA"
            }
            else
            {
                Singletone.reservationTextCheck = "DATA"
            }
            
            self.resInfoView.isHidden = false
            UIView.transition(with: self.resInfoView,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            
        })

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
        Singletone.reservationTextCheck = ""
        Singletone.restaurant_id = ""
        Singletone.check_staffcall_enable = ""
        Singletone.check_reservation_enable = ""
        Singletone.current_order = ""
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let findRes = storyBoard.instantiateViewController(withIdentifier: "FindRes") as! FindResController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(findRes, animated: false)
        
    }
    
    @IBAction func imageChange(_ sender: Any) {
        Circle_Image.image = UIImage(named: "circle_button_red")
    }
    
    @IBAction func imageReset(_ sender: Any) {
        Circle_Image.image = UIImage(named: "circle_button")
        
        self.ref?.child("res_staff_call").child(Singletone.restaurant_id).childByAutoId().setValue(["table_number": Singletone.table_number])
        
    }

}
