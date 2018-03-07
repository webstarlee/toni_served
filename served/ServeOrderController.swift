//
//  ServeOrderController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ServeOrderController: UIViewController {

    
    @IBOutlet weak var select_serve_type: UISegmentedControl!
    
    @IBOutlet weak var served_segmented_label: UILabel!
    
    @IBOutlet weak var picked_segmented_label: UILabel!
    
    @IBOutlet weak var order_body_filed: UITextView!
    
    @IBOutlet weak var table_number_label: UILabel!
    
    @IBOutlet weak var circle_image: UIImageView!
    
    var selected_order_key : String?
    
    var selected_serve_type_value : Int = 0
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        select_serve_type.selectedSegmentIndex = 0
        
        ref?.child("res_order").child(Singletone.restaurant_id).child(selected_order_key!).observeSingleEvent(of: .value, with: { (snapshot) in
            let order_info = snapshot.value as? [String: Any]
            if order_info != nil
            {
                let order_body = order_info?["order_body"] as? String
                let order_table_number = order_info?["table_number"] as? String
                
                self.order_body_filed.text = order_body?.uppercased()
                self.table_number_label.text = order_table_number
                
            }
            else
            {
                let alertController = UIAlertController(title: "FAILED", message: "WENT SOMETHING WRONG", preferredStyle: .alert)
                
                // Create Cancel button
                let cancelAction = UIAlertAction(title: "CLOSE", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(cancelAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
            }
        })
        
        served_segmented_label.textColor = UIColor.white
        picked_segmented_label.textColor = UIColor.black

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func Change_Serve_Type(_ sender: UISegmentedControl) {
        
        switch select_serve_type.selectedSegmentIndex {
        case 0:
            selected_serve_type_value = 0
            served_segmented_label.textColor = UIColor.white
            picked_segmented_label.textColor = UIColor.black
        case 1:
            selected_serve_type_value = 1
            served_segmented_label.textColor = UIColor.black
            picked_segmented_label.textColor = UIColor.white
        default:
            break
        }
    }
    
    @IBAction func Go_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeCircleImage(_ sender: Any) {
        circle_image.image = UIImage(named: "circle_button_red")
    }
    
    @IBAction func Complete_Order(_ sender: Any) {
        circle_image.image = UIImage(named: "circle_button")
        var state:String = ""
        if selected_serve_type_value == 0
        {
            state = "served"
        }
        else if selected_serve_type_value == 1
        {
            state = "picked"
        }
        
        ref?.child("res_order").child(Singletone.restaurant_id).child(selected_order_key!).child("state").setValue(state)
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let  viewOrder = storyBoard.instantiateViewController(withIdentifier: "ViewOrder") as! ViewOrderController
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(viewOrder, animated: false)
    }

}
