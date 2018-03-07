//
//  SendFeedBackController.swift
//  served
//
//  Created by firebase on 10/11/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SendFeedBackController: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    
    @IBOutlet weak var Send_order_Button: UIButton!
    
    @IBOutlet weak var Circle_Button_image: UIImageView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
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
    
    @IBAction func change_Image(_ sender: Any) {
        
        Circle_Button_image.image = UIImage(named: "circle_button_red")
        
    }
    
    @IBAction func sendFeedback(_ sender: Any) {
        
        Circle_Button_image.image = UIImage(named: "circle_button")
        
        let alertController = UIAlertController(title: "ÄR DU SÄKER?", message: "VILL DU SÄLJA DENNA ÅTERFÖRSÄLJNING ?", preferredStyle: .alert)
        
        let alertController_warning = UIAlertController(title: "OBS", message: "VÄLKOMMEN SKRIVA DIN FODBAKA", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "JA", style: .default) { (action:UIAlertAction!) in
            
            let feedbackSentences = self.feedbackTextView.text
            let date = Date()
            let timestamp_hash = Int(Date().timeIntervalSince1970)
            let timestamp = String(timestamp_hash)
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            
            let current_date = String(components.year!) + "-" + String(components.month!) + "-" + String(components.day!) + " " + String(components.hour!) + ":" + String(components.minute!) + ":" + String(components.second!)
            
            self.ref?.child("res_feedback").child(Singletone.restaurant_id).childByAutoId().setValue(["date":current_date, "timestamp":timestamp, "body":feedbackSentences])
            
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
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "NEJ", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController.addAction(cancelAction)
        
        
        let closeAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController_warning.addAction(closeAction)
        
        // Present Dialog message
        if feedbackTextView.text != ""
        {
            self.present(alertController, animated: true, completion:nil)
        }
        else
        {
            self.present(alertController_warning, animated: true, completion:nil)
        }
        
    }

}
