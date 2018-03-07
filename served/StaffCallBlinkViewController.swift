//
//  StaffCallBlinkViewController.swift
//  served
//
//  Created by firebase on 10/12/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import SpriteKit

class StaffCallBlinkViewController: UIViewController {

    @IBOutlet weak var blinkRoundView: RoundView!
    
    @IBOutlet weak var smallSubView: UIView!
    
    var repeatCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoundView.animate(withDuration: 0.3,
                          delay: 0,
                          options: [UIViewAnimationOptions.autoreverse, UIViewAnimationOptions.repeat, UIViewAnimationOptions.curveEaseInOut],
                          animations: {
                            self.blinkRoundView.backgroundColor = UIColor.yellow
                        },
                          completion: nil)
        
        UIView.animate(withDuration: 0.3,
                          delay: 0,
                          options: [UIViewAnimationOptions.autoreverse, UIViewAnimationOptions.repeat, UIViewAnimationOptions.allowAnimatedContent],
                          animations: {
                            self.smallSubView.backgroundColor = UIColor.red
        },
                          completion: nil)
      
        

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_back(_ sender: Any) {
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

}
