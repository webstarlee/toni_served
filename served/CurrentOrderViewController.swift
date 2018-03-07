//
//  CurrentOrderViewController.swift
//  served
//
//  Created by firebase on 10/10/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging

class CurrentOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var currentOrderTable: UITableView!
    
    var OrderList  = [Dictionary<String, String>]()
    
    @IBOutlet weak var orderDataLodingActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrderTable.isHidden = true
        
        currentOrderTable.delegate = self
        currentOrderTable.dataSource = self
        
        ref = Database.database().reference()
        
        ref?.child("res_order").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_check) in
            let order_check = snapshot_check.value as? [String:Any]
            
            if order_check != nil
            {
                
                var countlist:Int = 0
                
                for (key, val) in order_check!{
                    let order = val as? [String: Any]
                    let table_number = order?["table_number"] as? String
                    let order_body = order?["order_body"] as? String
                    let order_state = order?["state"] as? String
                    let current_timestamp = order?["timestamp"] as? String
                    let date = order?["date"] as? String
                    
                    let guestToken = order?["guest_token"] as? String
                    let tablenumber = order?["table_number"] as? String
                    let myToken: String = Messaging.messaging().fcmToken!
                    
                    if guestToken == myToken , Singletone.table_number == tablenumber
                    {
                        countlist += 1
                        
                        self.OrderList.append(["order_key": key,"table_number": table_number!,"order_boy": order_body!,"order_state": order_state!,"timestamp":current_timestamp!,"date":date!])
                    }
                }
                
                if countlist == 0
                {
                    let alertController = UIAlertController(title: "VARNA", message: "DET FINNS INGA ORDNINGAR", preferredStyle: .alert)
                    
                    
                    // Create Cancel button
                    let cancelAction = UIAlertAction(title: "STÄNGA", style: .cancel) { (action:UIAlertAction!) in
                    }
                    alertController.addAction(cancelAction)
                    
                    // Present Dialog message
                    self.present(alertController, animated: true, completion:nil)
                }
                
                self.sort_data()
                
                self.currentOrderTable.reloadData()
                self.currentOrderTable.isHidden = false
                self.orderDataLodingActivity.stopAnimating()
            }
            else
            {
                let alertController = UIAlertController(title: "VARNA", message: "DET FINNS INGA ORDNINGAR", preferredStyle: .alert)
                
                
                // Create Cancel button
                let cancelAction = UIAlertAction(title: "STÄNGA", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(cancelAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
                
                self.currentOrderTable.isHidden = false
                self.orderDataLodingActivity.stopAnimating()
                
            }
        })

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func sort_data() {
        OrderList = (OrderList as NSArray).sortedArray(using: [NSSortDescriptor(key: "timestamp", ascending: false)]) as! [[String:AnyObject]] as! [Dictionary<String, String>]
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return OrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = currentOrderTable.dequeueReusableCell(withIdentifier: "OrderBodyCell") as! CurrentOrderTableCell
        cell.OrderDateLabel.text = "BESTÄLLNING " + " " + OrderList[indexPath.row]["date"]!
        
        let order_state = OrderList[indexPath.row]["order_state"]
        
        if order_state == "sent"
        {
            cell.OrderStateLabel.text = "SKICKAT"
        }
        else if order_state == "served"
        {
            cell.OrderStateLabel.text = "FÄRDIG"
        }
        else if order_state == "picked"
        {
            cell.OrderStateLabel.text = "FÄRDIG"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentOrderTable.deselectRow(at: indexPath, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let currentOrderOneView = storyBoard.instantiateViewController(withIdentifier: "CurrentOrderOneView") as! CurrentOrderOneViewController
        
        
        currentOrderOneView.ThisOrderText = OrderList[indexPath.row]["order_boy"]!
        
        currentOrderOneView.modalPresentationStyle = .overCurrentContext
        currentOrderOneView.modalTransitionStyle = .crossDissolve
        present(currentOrderOneView, animated: true, completion: nil)
        
    }
    

}
