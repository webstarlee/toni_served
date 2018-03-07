//
//  FindResController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FindResController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SetTableNumberDelegate  {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var FindTableView: UITableView!
    
    @IBOutlet weak var dataLoadingActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    var RestaurantName  = [Dictionary<String, String>]()
    
    var FilterRestaurantName = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FindTableView.delegate = self
        FindTableView.dataSource = self
        SearchBar.delegate = self
        
        dataLoadingActivity.startAnimating()
        FindTableView.isHidden = true
        
        ref = Database.database().reference()
        ref?.child("res_list").observeSingleEvent(of: .value, with: { (snapshot_check) in
            
            let res_check = snapshot_check.value as? [String:Any]
            
            if res_check != nil
            {
                for (key, val) in res_check!{
                    
                    let res_info = val as? [String: Any]
                    let res_id = key
                    
                    let name = res_info?["name"] as! String
                    let address = res_info?["address"] as! String
                    let reservation_check = res_info?["reservation_check"] as! Bool
                    
                    var check_reservation :String = ""
                    var check_staffcall :String = ""
                    if reservation_check == false
                    {
                        check_reservation = "false"
                    }
                    else
                    {
                        check_reservation = "true"
                    }
                    
                    let staffcall_check = res_info?["staffcall_check"] as! Bool
                    
                    if staffcall_check == false
                    {
                        check_staffcall = "false"
                    }
                    else
                    {
                        check_staffcall = "true"
                    }
                    
                    
                    let id = res_id
                    
                    self.RestaurantName.append(["id":id,"name":name,"address":address,"check_reservation":check_reservation,"check_staffcall":check_staffcall])
                    
                    self.sort_data()
                    
                    self.FilterRestaurantName = self.RestaurantName
                    self.FindTableView.reloadData()
                    self.FindTableView.isHidden = false
                    self.dataLoadingActivity.stopAnimating()
                    
                }
            }
            else
            {
                let alertController = UIAlertController(title: "DATA LOAD FAILED", message: "DET ÄR INTE EN RESTAURANT", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "STÄNGA", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(closeAction)
                
                // Present Dialog message
                self.present(alertController, animated: true, completion:nil)
                
                self.FindTableView.isHidden = false
                self.dataLoadingActivity.stopAnimating()
                
            }
            
        })

        // Do any additional setup after loading the view.
    }
    
    func sort_data() {
        RestaurantName = (RestaurantName as NSArray).sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [[String:AnyObject]] as! [Dictionary<String, String>]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
        Singletone.table_number = ""
        Singletone.guest_type = ""
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let beforeFindRes = storyBoard.instantiateViewController(withIdentifier: "BeforeFindRes") as! BeforeFindResController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(beforeFindRes, animated: false)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterRestaurantName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FindTableView.dequeueReusableCell(withIdentifier: "resInfoCell") as! FindResTableCell
        
        cell.findResName.text! = (FilterRestaurantName[indexPath.row]["name"]?.uppercased())!
        cell.findResAddress.text! = (FilterRestaurantName[indexPath.row]["address"]?.uppercased())!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FindTableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let setTableNumber = storyBoard.instantiateViewController(withIdentifier: "SetTableNumber") as! SetTableNumberController
        
        setTableNumber.forSetResId = FilterRestaurantName[indexPath.row]["id"]!
        setTableNumber.forSetCheckReservation = FilterRestaurantName[indexPath.row]["check_reservation"]!
        setTableNumber.forSetCheckStaffCall = FilterRestaurantName[indexPath.row]["check_staffcall"]!
        
        
        setTableNumber.delegate = self;
        
        setTableNumber.modalPresentationStyle = .overCurrentContext
        setTableNumber.modalTransitionStyle = .crossDissolve
        present(setTableNumber, animated: true, completion: nil)
    }
    
    func goTo_selectedRes() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedRes = storyBoard.instantiateViewController(withIdentifier: "SelectedRes") as! SelectedResController
        
        
        self.navigationController?.pushViewController(selectedRes, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        FilterRestaurantName = searchText.isEmpty ? RestaurantName : RestaurantName.filter({(dict:[String:String]) -> Bool in
            return (dict["name"]?.lowercased().contains(searchText.lowercased()))!
        })
        
        FindTableView.reloadData()
    }

}
