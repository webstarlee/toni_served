//
//  CurrentOrderOneViewController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit

class CurrentOrderOneViewController: UIViewController {

    @IBOutlet weak var OrderBodyTextView: UITextView!
    
    @IBOutlet weak var OrderStateLabel: UILabel!
    
    var ThisOrderText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OrderBodyTextView.text = ThisOrderText

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
