//
//  SingleFeedbackController.swift
//  served
//
//  Created by firebase on 10/16/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit

class SingleFeedbackController: UIViewController {

    @IBOutlet weak var viewFeedbacktext: UITextView!
    
    var forSetFeedbacktext:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewFeedbacktext.text = forSetFeedbacktext

        // Do any additional setup after loading the view.
    }

    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
