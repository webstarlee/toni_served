//
//  ViewCompletedOrderController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit

class ViewCompletedOrderController: UIViewController {

    @IBOutlet weak var OrderStateLabel: UILabel!
    
    @IBOutlet weak var OrderBodyLabel: UITextView!
    
    @IBOutlet weak var OrderTableNumber: UILabel!
    
    var textOrderState:String = ""
    var textOrderBody:String = ""
    var textOrderTablenumber:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OrderStateLabel.text = ""
        OrderBodyLabel.text = textOrderBody.uppercased()
        OrderTableNumber.text = textOrderTablenumber

        // Do any additional setup after loading the view.
    }

    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
