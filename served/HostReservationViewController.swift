//
//  HostReservationViewController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HostReservationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var HostReservationTable: UITableView!
    
    var ReservationList  = [Dictionary<String, String>]() 
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HostReservationTable.delegate = self
        HostReservationTable.dataSource = self
        
        HostReservationTable.isHidden = true
        loadingActivity.startAnimating()
        
        ref = Database.database().reference()
        
        ref?.child("res_reservation").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_check) in
            let reservation_check = snapshot_check.value as? [String:Any]
            
            if reservation_check != nil
            {
                
                for (key, val) in reservation_check!{
                    let reservation = val as? [String: Any]
                    
                    let date = reservation?["makeTime"] as? String
                    let state = reservation?["state"] as? String
                    let name = reservation?["name"] as? String
                    let personalNumber = reservation?["personalNumber"] as? String
                    let phoneNumber = reservation?["phoneNumber"] as? String
                    let arriveTime = reservation?["arriveTime"] as? String
                    let allGuests = reservation?["guestsNumber"] as? String
                    let current_timestamp = reservation?["timestamp"] as? String
                    
                    self.ReservationList.append(["reservation_key": key,"name": name! ,"per_number":personalNumber!,"phone": phoneNumber!, "arrive_time": arriveTime!, "guests_number": allGuests!,"date": date!,"reservation_state": state!,"timestamp":current_timestamp!])
                }
                
                self.sort_data()
                
                self.HostReservationTable.reloadData()
                self.HostReservationTable.isHidden = false
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
                
                self.HostReservationTable.isHidden = false
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
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resMain = storyBoard.instantiateViewController(withIdentifier: "ResMain") as! ResMainController
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(resMain, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ReservationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = HostReservationTable.dequeueReusableCell(withIdentifier: "reservationBodyCell") as! HostReservationTableCell
        cell.reservationBodyCellLabel.text = "RESERVATION FROM" + " " + (ReservationList[indexPath.row]["name"]!).uppercased()
        cell.reservationDateCellLabel.text = ReservationList[indexPath.row]["date"]
        
        let reservation_state = ReservationList[indexPath.row]["reservation_state"]
        
        if reservation_state == "sent"
        {
            cell.reservationStateCellLabel.text = "NEW"
        }
        else if reservation_state == "accept"
        {
            cell.reservationStateCellLabel.text = "ACCEPTED"
        }
        else if reservation_state == "reject"
        {
            cell.reservationStateCellLabel.text = "REJECTED"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HostReservationTable.deselectRow(at: indexPath, animated: true)
        
        let reservation_state = ReservationList[indexPath.row]["reservation_state"]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if reservation_state == "sent"
        {
            
            let HostCompleteReservation = storyBoard.instantiateViewController(withIdentifier: "HostCompleteReservation") as! HostCompleteReservationController
            
            HostCompleteReservation.settingName = ReservationList[indexPath.row]["name"]!
            HostCompleteReservation.settingPersonalNumber = ReservationList[indexPath.row]["per_number"]!
            HostCompleteReservation.settingPhoneNumber = ReservationList[indexPath.row]["phone"]!
            HostCompleteReservation.settingArriveTime = ReservationList[indexPath.row]["arrive_time"]!
            HostCompleteReservation.settingGuestsNumber = ReservationList[indexPath.row]["guests_number"]!
            HostCompleteReservation.reservationKey = ReservationList[indexPath.row]["reservation_key"]!
            
            self.navigationController?.pushViewController(HostCompleteReservation, animated: true)
        }
        else if reservation_state == "accept" || reservation_state == "reject"
        {
            let hostCompletedReservation = storyBoard.instantiateViewController(withIdentifier: "HostCompletedReservation") as! HostCompletedReservationController
            
            var currentReservationState:String = ""
            
            if reservation_state == "accept"
            {
                currentReservationState = "ACCEPTED"
            }
            else if reservation_state == "reject"
            {
                currentReservationState = "REJECTED"
            }
            
            hostCompletedReservation.settingState = currentReservationState
            hostCompletedReservation.settingName = ReservationList[indexPath.row]["name"]!
            hostCompletedReservation.settingPersonalNumber = ReservationList[indexPath.row]["per_number"]!
            hostCompletedReservation.settingPhoneNumber = ReservationList[indexPath.row]["phone"]!
            hostCompletedReservation.settingArriveTime = ReservationList[indexPath.row]["arrive_time"]!
            hostCompletedReservation.settingGuestsNumber = ReservationList[indexPath.row]["guests_number"]!
            
            hostCompletedReservation.modalPresentationStyle = .overCurrentContext
            hostCompletedReservation.modalTransitionStyle = .crossDissolve
            present(hostCompletedReservation, animated: true, completion: nil)
        }
        
    }

}
