//
//  ViewReservationRequestController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class ViewReservationRequestController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var reservationBodyTable: UITableView!
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var ReservationList  = [Dictionary<String, String>]()
    
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservationBodyTable.isHidden = true
        loadingActivity.startAnimating()
        
        reservationBodyTable.delegate = self
        reservationBodyTable.dataSource = self
        
        ref = Database.database().reference()
        
        ref?.child("res_reservation").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_check) in
            let reservation_check = snapshot_check.value as? [String:Any]
            
            if reservation_check != nil
            {
                var countlist:Int = 0
                
                for (key, val) in reservation_check!{
                    let reservation = val as? [String: Any]
                    
                    let date = reservation?["makeTime"] as? String
                    let state = reservation?["state"] as? String
                    let current_timestamp = reservation?["timestamp"] as? String
                    
                    let guestToken = reservation?["guest_token"] as? String
                    let myToken: String = Messaging.messaging().fcmToken!
                    
                    if guestToken == myToken
                    {
                        countlist += 1
                        
                        self.ReservationList.append(["reservation_key": key,"date": date!,"reservation_state": state!,"timestamp":current_timestamp!])
                    }
                }
                
                if countlist == 0
                {
                    let alertController = UIAlertController(title: "VARNA", message: "DET ÄR INTE NÅGOT RESERVERING", preferredStyle: .alert)
                    
                    
                    // Create Cancel button
                    let cancelAction = UIAlertAction(title: "STÄNGA", style: .cancel) { (action:UIAlertAction!) in
                    }
                    alertController.addAction(cancelAction)
                    
                    // Present Dialog message
                    self.present(alertController, animated: true, completion:nil)
                }
                
                self.sort_data()
                
                self.reservationBodyTable.reloadData()
                self.reservationBodyTable.isHidden = false
                self.loadingActivity.stopAnimating()
            }
            else
            {
                let alertController = UIAlertController(title: "VARNA", message: "DET ÄR INTE NÅGOT RESERVERING", preferredStyle: .alert)
                
                
                // Create Cancel button
                let cancelAction = UIAlertAction(title: "STÄNGA", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(cancelAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
                
                self.reservationBodyTable.isHidden = false
                self.loadingActivity.stopAnimating()
                
            }
        })

        // Do any additional setup after loading the view.
    }
    
    func sort_data() {
        ReservationList = (ReservationList as NSArray).sortedArray(using: [NSSortDescriptor(key: "timestamp", ascending: false)]) as! [[String:AnyObject]] as! [Dictionary<String, String>]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectReservationType = storyBoard.instantiateViewController(withIdentifier: "SelectReservationType") as! SelectReservationTypeController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(selectReservationType, animated: false)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ReservationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = reservationBodyTable.dequeueReusableCell(withIdentifier: "reservationListCell") as! ViewReservationTableCell
        cell.reservationDate.text = "RESERVATION " + " " + ReservationList[indexPath.row]["date"]!
        
        let reservation_state = ReservationList[indexPath.row]["reservation_state"]
        
        if reservation_state == "sent"
        {
            cell.reservationState.text = "SENT"
        }
        else if reservation_state == "accept"
        {
            cell.reservationState.text = "ACCEPTED"
        }
        else if reservation_state == "reject"
        {
            cell.reservationState.text = "REJECTED"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reservationBodyTable.deselectRow(at: indexPath, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewOneReservationController = storyBoard.instantiateViewController(withIdentifier: "ViewOneReservation") as! ViewOneReservationController
        
        viewOneReservationController.currentReservationKey = ReservationList[indexPath.row]["reservation_key"]!
        
        viewOneReservationController.modalPresentationStyle = .overCurrentContext
        viewOneReservationController.modalTransitionStyle = .crossDissolve
        present(viewOneReservationController, animated: true, completion: nil)
    }

}
