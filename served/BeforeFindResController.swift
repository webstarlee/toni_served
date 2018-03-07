//
//  BeforeFindResController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit

class BeforeFindResController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
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
    

}
