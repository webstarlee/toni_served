//
//  HostCompletedReservationController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit

class HostCompletedReservationController: UIViewController {

    @IBOutlet weak var reservationerName: UILabel!
    
    @IBOutlet weak var reservationerPersonalNumber: UILabel!
    
    @IBOutlet weak var reservationerPhoneNumber: UILabel!
    
    @IBOutlet weak var reservationerArriveTime: UILabel!
    
    @IBOutlet weak var reservationerGuestsNumber: UILabel!
    
    var settingName:String = ""
    
    var settingPersonalNumber:String = ""
    
    var settingPhoneNumber:String = ""
    
    var settingArriveTime:String = ""
    
    var settingGuestsNumber:String = ""
    
    var settingState:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservationerName.text = "NAME : " + settingName.uppercased()
        
        reservationerPersonalNumber.text = "PERSONAL NUMBER : " + settingPersonalNumber
        
        reservationerPhoneNumber.text = "PHONE NUMBER : " + settingPhoneNumber
        
        reservationerArriveTime.text = "ARRIVED TIME : " + settingArriveTime
        
        reservationerGuestsNumber.text = "ALL GUESTS : " + settingGuestsNumber

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
