//
//  SelectMenuController.swift
//  served
//
//  Created by firebase on 10/8/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectMenuController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var guestMenuTable: UITableView!
    
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
        
        guestMenuTable.delegate = self
        guestMenuTable.dataSource = self
        
        guestMenuTable.isHidden = true
        menuloadingActivity.startAnimating()
        
        ref = Database.database().reference()
        
        self.ref?.child("menu_kind").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_kind) in
            
            let res_kind_check = snapshot_kind.value as? [String: Any]
            
            if res_kind_check != nil
            {
                for (key, val) in res_kind_check!{
                    
                    var food_kind : String = ""
                    
                    var food_kind_key : String = ""
                    
                    var food_list = [Dictionary<String,String>]()
                    
                    food_kind = val as! String
                    food_kind_key = key
                    
                    self.ref?.child("menu_food").child(Singletone.restaurant_id).child(key).observeSingleEvent(of: .value, with: { (snapshot_food) in
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
                        
                        self.guestMenuTable.reloadData()
                        self.guestMenuTable.isHidden = false
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
        let cell = guestMenuTable.dequeueReusableCell(withIdentifier: "menuCell") as! SelectMenuTableCell
        
        cell.menuCellFoodName.text = objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased()
        cell.menuCellFoodMaterial.text = objectsArray[indexPath.section].list[indexPath.row]["body"]?.uppercased()
        cell.menuCellFoodPrice.text = objectsArray[indexPath.section].list[indexPath.row]["price"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = guestMenuTable.dequeueReusableCell(withIdentifier: "menuHeader") as! SelectMenuTableCell
        
        header.menuHeaderLabel.text = objectsArray[section].kind.uppercased()
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guestMenuTable.deselectRow(at: indexPath, animated: true)
        
        //Section 2
        
        let alertController = UIAlertController(title: "DU VALDE \n"+(objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased())!, message: "PRIS ÄR "+objectsArray[indexPath.section].list[indexPath.row]["price"]!+" SEK PER EN SKAL \n"+" \nANGE ANTAL", preferredStyle: .alert)
        
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
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.textAlignment = .center
            textField.font = UIFont(name: "Calibri", size: 20)
        })
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "AVBRYT", style: .cancel) { (action:UIAlertAction!) in
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
    
    @IBAction func Back_Menu_Editor(_ sender: Any) {
        
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
    
    @IBAction func goTo_Beverage(_ sender: Any) {
        
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
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectBeverage = storyBoard.instantiateViewController(withIdentifier: "SelectBeverage") as! SelectBeverageController
        
        self.navigationController?.pushViewController(selectBeverage, animated: true)
        
    }
    
}
