//
//  FeedbackViewController.swift
//  served
//
//  Created by firebase on 10/16/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedbackViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var FeedbackTable: UITableView!
    
    var feedbackList  = [Dictionary<String, String>]()
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedbackTable.delegate = self
        FeedbackTable.dataSource = self
        
        FeedbackTable.isHidden = true
        loadingActivity.startAnimating()
        
        ref = Database.database().reference()
        
        ref?.child("res_feedback").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_check) in
            let feedback_check = snapshot_check.value as? [String:Any]
            
            if feedback_check != nil
            {
                
                for (key, val) in feedback_check!{
                    let feedback = val as? [String: Any]
                    
                    let date = feedback?["date"] as? String
                    let stampeTime = feedback?["timestamp"] as? String
                    let body = feedback?["body"] as? String
                    
                    self.feedbackList.append(["feedback_id":key, "body":body!, "date":date!, "timestamp":stampeTime!])
                }
                
                self.sort_data()
                
                self.FeedbackTable.reloadData()
                self.FeedbackTable.isHidden = false
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
                
                self.FeedbackTable.isHidden = false
                self.loadingActivity.stopAnimating()
                
            }
        })

        // Do any additional setup after loading the view.
    }
    
    func sort_data() {
        feedbackList = (feedbackList as NSArray).sortedArray(using: [NSSortDescriptor(key: "timestamp", ascending: false)]) as! [[String:AnyObject]] as! [Dictionary<String, String>]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_back(_ sender: Any) {
        
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
        
        return feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = FeedbackTable.dequeueReusableCell(withIdentifier: "feedbackbodyCell") as! FeedbackTableCell
        
        cell.feebackBody.text = feedbackList[indexPath.row]["date"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FeedbackTable.deselectRow(at: indexPath, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let singleFeedback = storyBoard.instantiateViewController(withIdentifier: "SingleFeedback") as! SingleFeedbackController
        
        singleFeedback.forSetFeedbacktext = feedbackList[indexPath.row]["body"]!
        
        singleFeedback.modalPresentationStyle = .overCurrentContext
        singleFeedback.modalTransitionStyle = .crossDissolve
        present(singleFeedback, animated: true, completion: nil)
        
    }

}
