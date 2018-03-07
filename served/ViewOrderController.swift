//
//  ViewOrderController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewOrderController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var ViewOrderTableView: UITableView!
    
    var OrderList  = [Dictionary<String, String>]()
    
    @IBOutlet weak var orderDataLodingActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderDataLodingActivity.startAnimating()
        ViewOrderTableView.isHidden = true
        
        ViewOrderTableView.delegate = self
        ViewOrderTableView.dataSource = self
        
        ref = Database.database().reference()
        
        ref?.child("res_order").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_check) in
            let order_check = snapshot_check.value as? [String:Any]
            
            if order_check != nil
            {
                for (key, val) in order_check!{
                    let order = val as? [String: Any]
                    let table_number = order?["table_number"] as? String
                    let order_body = order?["order_body"] as? String
                    let order_state = order?["state"] as? String
                    let current_timestamp = order?["timestamp"] as? String
                    let date = order?["date"] as? String
                    
                    self.OrderList.append(["order_key": key,"table_number": table_number!,"order_boy": order_body!,"order_state": order_state!,"timestamp":current_timestamp!,"date":date!])
                }
                
                self.sort_data()
                
                self.ViewOrderTableView.reloadData()
                self.ViewOrderTableView.isHidden = false
                self.orderDataLodingActivity.stopAnimating()
            }
            else
            {
                let alertController = UIAlertController(title: "OBS", message: "INGEN BORDSBOKNING TILLGÄNGLIG", preferredStyle: .alert)
                
                
                // Create Cancel button
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(cancelAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
                
                self.ViewOrderTableView.isHidden = false
                self.orderDataLodingActivity.stopAnimating()
                
            }
        })

        // Do any additional setup after loading the view.
    }
    
    func sort_data() {
        OrderList = (OrderList as NSArray).sortedArray(using: [NSSortDescriptor(key: "timestamp", ascending: false)]) as! [[String:AnyObject]] as! [Dictionary<String, String>]
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
        
        return OrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ViewOrderTableView.dequeueReusableCell(withIdentifier: "orderBodyCell") as! HostOrderViewTableCell
        cell.orderTablenumber.text = "BORD " + OrderList[indexPath.row]["table_number"]!
        cell.orderTime.text = OrderList[indexPath.row]["date"]!
        
        let order_state = OrderList[indexPath.row]["order_state"]
        
        if order_state == "sent"
        {
            cell.orderState.text = "NY"
        }
        else if order_state == "served"
        {
            cell.orderState.text = "FÄRDIG"
        }
        else if order_state == "picked"
        {
            cell.orderState.text = "FÄRDIG"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewOrderTableView.deselectRow(at: indexPath, animated: true)
        
        let order_state = OrderList[indexPath.row]["order_state"]
        
        if order_state == "sent"
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let serveOrder = storyBoard.instantiateViewController(withIdentifier: "ServeOrder") as! ServeOrderController
            
            serveOrder.selected_order_key = OrderList[indexPath.row]["order_key"]!
            
            self.navigationController?.pushViewController(serveOrder, animated: true)
        }
        else if order_state == "served" || order_state == "picked"
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewCompletedOrder = storyBoard.instantiateViewController(withIdentifier: "ViewCompletedOrder") as! ViewCompletedOrderController
            
            if order_state == "served"
            {
                viewCompletedOrder.textOrderState = "FÄRDIG"
            }
            else if order_state == "picked"
            {
                viewCompletedOrder.textOrderState = "FÄRDIG"
            }
            
            viewCompletedOrder.textOrderTablenumber = OrderList[indexPath.row]["table_number"]!
            viewCompletedOrder.textOrderBody = OrderList[indexPath.row]["order_boy"]!
            
            viewCompletedOrder.modalPresentationStyle = .overCurrentContext
            viewCompletedOrder.modalTransitionStyle = .crossDissolve
            present(viewCompletedOrder, animated: true, completion: nil)
        }
    }

}
