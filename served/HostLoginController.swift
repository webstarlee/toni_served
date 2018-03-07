//
//  HostLoginController.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HostLoginController: UIViewController {

    @IBOutlet weak var loginPassword: RoundTextFiled!
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var whiteLoadingView: RoundView!
    
    @IBOutlet weak var animatinfActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func backTo_startView(_ sender: Any) {
        
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
    
    @IBAction func login(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if loginPassword.text != ""
        {
            overlayView.isHidden = false
            
            animatinfActivity.startAnimating()
            
            self.whiteLoadingView.isHidden = false
            UIView.transition(with: self.whiteLoadingView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            
            Auth.auth().signIn(withEmail: "firebase.served@support.com", password: loginPassword.text!) { (user, error) in
            
                if user != nil
                {
                    var auto_restarantId:String = ""
                    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                        auto_restarantId = uuid
                    }
                    
                    Singletone.restaurant_id = auto_restarantId
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    self.ref?.child("res_list").child(auto_restarantId).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if (snapshot.value as? [String: Any]) != nil
                        {
                            let resMain = storyBoard.instantiateViewController(withIdentifier: "ResMain") as! ResMainController
                            
                            self.navigationController?.pushViewController(resMain, animated: true)
                        }else{
                            let makeRes = storyBoard.instantiateViewController(withIdentifier: "MakeRes") as! MakeResController
                            
                            self.navigationController?.pushViewController(makeRes, animated: true)
                        }
                        
                        self.overlayView.isHidden = true
                        self.whiteLoadingView.isHidden = true
                        UIView.transition(with: self.whiteLoadingView,
                                          duration: 0.5,
                                          options: .transitionCrossDissolve,
                                          animations: nil,
                                          completion: nil)
                        self.animatinfActivity.stopAnimating()
                        
                    })
                    
                }
                else
                {
                    if let myError = error?.localizedDescription
                    {
                        print(myError)
                        let alertController = UIAlertController(title: "INLOGGNINGEN MISSLYCKADES", message: "LÖSENORDET ÄR FELAKTIGT", preferredStyle: .alert)
                        let closeAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
                        }
                        alertController.addAction(closeAction)
                        
                        // Present Dialog message
                        self.present(alertController, animated: true, completion:nil)
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "INLOGGNINGEN MISSLYCKADES", message: "NÅGOT GICK FEL", preferredStyle: .alert)
                        let closeAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
                        }
                        alertController.addAction(closeAction)
                        
                        // Present Dialog message
                        self.present(alertController, animated: true, completion:nil)
                    }
                    
                    self.overlayView.isHidden = true
                    self.whiteLoadingView.isHidden = true
                    UIView.transition(with: self.whiteLoadingView,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: nil,
                                      completion: nil)
                    self.animatinfActivity.stopAnimating()
                    
                }
            }
        }
        else
        {
            let alertController = UIAlertController(title: "ALERT!", message: "PLEASE ENTER PASSWORD", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(closeAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
        }
        
    }
    

}
