//
//  SelectBecerageController.swift
//  served
//
//  Created by firebase on 10/9/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectBeverageController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var beverageTableView: UITableView!
    
    var make_order_string : String = ""
    
    @IBOutlet weak var menuloadingActivity: UIActivityIndicatorView!
    
    
    var ref:DatabaseReference?
    
    struct Objects {
        var kind : String!
        var key : String!
        var list = [Dictionary<String,String>]()
    }
    
    var objectsArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beverageTableView.delegate = self
        beverageTableView.dataSource = self
        
        beverageTableView.isHidden = true
        menuloadingActivity.startAnimating()
        
        ref = Database.database().reference()
        
        self.ref?.child("menu_beverage_kind").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_kind) in
            
            let res_kind_check = snapshot_kind.value as? [String: Any]
            
            if res_kind_check != nil
            {
                for (key, val) in res_kind_check!{
                    
                    var food_kind : String = ""
                    
                    var food_kind_key : String = ""
                    
                    var food_list = [Dictionary<String,String>]()
                    
                    food_kind = val as! String
                    food_kind_key = key
                    
                    self.ref?.child("menu_beverage").child(Singletone.restaurant_id).child(key).observeSingleEvent(of: .value, with: { (snapshot_food) in
                        let res_food_check = snapshot_food.value as? [String: Any]
                        
                        if res_food_check != nil
                        {
                            
                            for (food_key, food_value) in res_food_check! {
                                let food = food_value as! [String: Any]
                                let food_name = food["name"] as! String
                                let food_material = food["material"] as! String
                                let food_price = food["price"] as! String
                                
                                food_list.append(["title":food_name,"body":food_material,"price":food_price,"food_key":food_key])
                                
                            }
                            
                        }else
                        {
                            food_list = [Dictionary<String,String>]()
                        }
                        
                        self.objectsArray.append(Objects(kind: food_kind,key: food_kind_key, list:food_list))
                        
                        self.beverageTableView.reloadData()
                        self.beverageTableView.isHidden = false
                        self.menuloadingActivity.stopAnimating()
                        
                    })
                    
                }
            }
            else
            {
            }
            
        })

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = beverageTableView.dequeueReusableCell(withIdentifier: "beverageCell") as! SelectMenuTableCell
        
        cell.beverageCellBeverageName.text = objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased()
        cell.beverageCellBeveragematerial.text = objectsArray[indexPath.section].list[indexPath.row]["body"]?.uppercased()
        cell.beverageCellBeveragePrice.text = objectsArray[indexPath.section].list[indexPath.row]["price"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = beverageTableView.dequeueReusableCell(withIdentifier: "beverageHeader") as! SelectMenuTableCell
        
        header.beverageHeaderlabel.text = objectsArray[section].kind.uppercased()
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        beverageTableView.deselectRow(at: indexPath, animated: true)
        
        let alertController = UIAlertController(title: "-DU VALGADE- \n"+(objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased())!, message: "PRIS ÄR "+objectsArray[indexPath.section].list[indexPath.row]["price"]!+" SEK PER EN SKAL \n"+" \nVÄNSTER ANVÄNDER MAT FÖR MAT", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            //Section 1
            let amount_of_food = alertController.textFields![0] as UITextField
            
            if amount_of_food.text != "" , Int(amount_of_food.text!) != nil , Int(amount_of_food.text!) != 0 {
                
                
                if self.make_order_string != ""
                {
                    self.make_order_string = self.make_order_string + "\n" + (self.objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased())! + " -x" + amount_of_food.text!
                }
                else
                {
                    self.make_order_string = self.make_order_string + (self.objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased())! + " -x" + amount_of_food.text!
                }
                
            }
            else
            {
                self.Number_validate()
            }
        }))
        
        //Section 2
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.textAlignment = .center
            textField.font = UIFont(name: "Calibri", size: 20)
        })
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "ANNULLERA", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    func Number_validate() {
        
        let alertController = UIAlertController(title: "OBS", message: "ANVÄND ENDAST ENDAST NUMMER", preferredStyle: .alert)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
        if make_order_string != ""
        {
            if Singletone.current_order != ""
            {
                Singletone.current_order = Singletone.current_order + "\n" + make_order_string
            }
            else
            {
                Singletone.current_order = Singletone.current_order + make_order_string
            }
        }
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let makeOrder = storyBoard.instantiateViewController(withIdentifier: "MakeOrder") as! MakeOrderController
        
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(makeOrder, animated: false)
        
    }
    
    @IBAction func goTo_Food(_ sender: Any) {
        
        if make_order_string != ""
        {
            if Singletone.current_order != ""
            {
                Singletone.current_order = Singletone.current_order + "\n" + make_order_string
            }
            else
            {
                Singletone.current_order = Singletone.current_order + make_order_string
            }
        }
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectMenu = storyBoard.instantiateViewController(withIdentifier: "SelectMenu") as! SelectMenuController
        
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(selectMenu, animated: false)
    }

}
