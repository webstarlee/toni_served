//
//  ViewController.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class ViewController: UIViewController {

    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func goTo_Hostlogin(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "hostLogin") as! HostLoginController
        self.navigationController?.pushViewController(loginController, animated: true)
    }
    
    @IBAction func appExit(_ sender: Any) {

        exit(0)
        
    }

}

