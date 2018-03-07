//
//  BeverageMakeController.swift
//  served
//
//  Created by firebase on 10/9/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BeverageMakeController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddBeverageDelegate,AddBeverageKindDelegate,EditBeverageDelegate {

    @IBOutlet weak var BeverageTable: UITableView!
    
    @IBOutlet weak var nowLoadingActivity: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    var restarantId = Singletone.restaurant_id
    
    struct Objects {
        var kind : String!
        var key : String!
        var list = [Dictionary<String,String>]()
    }
    
    var objectsArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowLoadingActivity.startAnimating()
        
        BeverageTable.delegate = self
        BeverageTable.dataSource = self
        BeverageTable.isHidden = true
        
        ref = Database.database().reference()
        
        self.ref?.child("menu_beverage_kind").child(self.restarantId).observeSingleEvent(of: .value, with: { (snapshot_kind) in
            
            let res_kind_check = snapshot_kind.value as? [String: Any]
            
            if res_kind_check != nil
            {
                for (key, val) in res_kind_check!{
                    
                    var food_kind : String = ""
                    
                    var food_key : String = ""
                    
                    var food_list = [Dictionary<String,String>]()
                    
                    food_kind = val as! String
                    food_key = key
                    
                    self.ref?.child("menu_beverage").child(self.restarantId).child(key).observeSingleEvent(of: .value, with: { (snapshot_food) in
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
                        
                        self.objectsArray.append(Objects(kind: food_kind,key: food_key, list:food_list))
                        
                        self.BeverageTable.reloadData()
                        
                        self.BeverageTable.isHidden = false
                        
                        self.nowLoadingActivity.stopAnimating()
                        
                    })
                    
                }
            }
            else{
                self.BeverageTable.isHidden = false
                self.nowLoadingActivity.stopAnimating()
            }
        })

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goTo_Back(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resMain = storyBoard.instantiateViewController(withIdentifier: "ResMain") as! ResMainController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.pushViewController(resMain, animated: false)
        
    }
    
    @IBAction func goTo_Food(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuMake = storyBoard.instantiateViewController(withIdentifier: "MenuMake") as! MenuMakeController
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.pushViewController(menuMake, animated: false)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count + 1
    }//end
    
    //tableview cell number define
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var number_section: Int = 0
        
        if section < objectsArray.count
        {
            //cell count defined more one than real cell number for add new food button
            number_section = objectsArray[section].list.count + 1
        }else if section == objectsArray.count
        {
            //when last section return o cell
            number_section = 0
        }
        return number_section
    }
    //end
    
    //tableview cell define
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //general cell define
        var cell = BeverageTable.dequeueReusableCell(withIdentifier: "cellBeverage") as! HostMenuTableCell
        
        if indexPath.row < objectsArray[indexPath.section].list.count
        {
            //cell texts define
            cell.cellBeverageName.text = objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased()
            cell.cellBeverageMaterial.text = objectsArray[indexPath.section].list[indexPath.row]["body"]?.uppercased()
            cell.cellBeveragePrice.text = objectsArray[indexPath.section].list[indexPath.row]["price"]!
        }else if indexPath.row == objectsArray[indexPath.section].list.count
        {
            //when last cell for make add new food button
            cell = BeverageTable.dequeueReusableCell(withIdentifier: "addNewBeverage")! as! HostMenuTableCell
        }
        
        return cell
    }
    //end
    
    //tableview header define
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //general header
        var header = BeverageTable.dequeueReusableCell(withIdentifier: "BeverageheaderKind") as! HostMenuTableCell
        
        if section < objectsArray.count
        {
            //header text define
            header.BeverageHeaderkindLabel.text = objectsArray[section].kind.uppercased()
        }else if section == objectsArray.count
        {
            //when last make kind add button
            header = BeverageTable.dequeueReusableCell(withIdentifier: "addNewBeverageKind") as! HostMenuTableCell
        }
        
        return header
    }
    //end
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    //when clicking the table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        BeverageTable.deselectRow(at: indexPath, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if indexPath.row < objectsArray[indexPath.section].list.count
        {
            let editBeverageController = storyBoard.instantiateViewController(withIdentifier: "EditBeverage") as! EditBeverageController
            
            editBeverageController.delegate = self;
            
            editBeverageController.set_beverage_name = objectsArray[indexPath.section].list[indexPath.row]["title"]!
            editBeverageController.set_beverage_material = objectsArray[indexPath.section].list[indexPath.row]["body"]!
            editBeverageController.set_beverage_price = objectsArray[indexPath.section].list[indexPath.row]["price"]!
            editBeverageController.set_beverage_kind_key = objectsArray[indexPath.section].key
            editBeverageController.set_beverage_key = objectsArray[indexPath.section].list[indexPath.row]["food_key"]!
            
            //make popup
            editBeverageController.modalPresentationStyle = .overCurrentContext
            editBeverageController.modalTransitionStyle = .crossDissolve
            present(editBeverageController, animated: true, completion: nil)
            //end
        }
        
        if indexPath.row == objectsArray[indexPath.section].list.count
        {
            
            let addBeverageController = storyBoard.instantiateViewController(withIdentifier: "AddBeverage") as! AddBeverageController
            
            //delegate to self for reload data when dismiss popup
            addBeverageController.delegate = self;
            
            //define menu kind for add new food
            addBeverageController.beverage_Kind_Name = objectsArray[indexPath.section].kind!
            addBeverageController.beverage_Kind_Key = objectsArray[indexPath.section].key!
            
            //make popup
            addBeverageController.modalPresentationStyle = .overCurrentContext
            addBeverageController.modalTransitionStyle = .crossDissolve
            present(addBeverageController, animated: true, completion: nil)
            //end
        }
    }
    //end
    
    @IBAction func Add_NewKind(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addBeverageKindController = storyBoard.instantiateViewController(withIdentifier: "AddBeverageKind") as! AddBeverageKindController
        
        addBeverageKindController.delegate = self;
        
        addBeverageKindController.modalPresentationStyle = .overCurrentContext
        addBeverageKindController.modalTransitionStyle = .crossDissolve
        present(addBeverageKindController, animated: true, completion: nil)
    }
    
    
    func addedNewBeverage() {
        
        self.BeverageTable.isHidden = true
        self.nowLoadingActivity.startAnimating()
        
        //define obkectArray to nil again
        objectsArray = [Objects]()
        
        
        //reload all data
        self.ref?.child("menu_beverage_kind").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_kind) in
            
            let res_kind_check = snapshot_kind.value as? [String: Any]
            
            if res_kind_check != nil
            {
                for (key, val) in res_kind_check!{
                    
                    var food_kind : String = ""
                    
                    var food_key : String = ""
                    
                    var food_list = [Dictionary<String,String>]()
                    
                    food_kind = val as! String
                    food_key = key
                    
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
                        
                        self.objectsArray.append(Objects(kind: food_kind,key: food_key, list:food_list))
                        
                        self.BeverageTable.reloadData()
                        self.BeverageTable.isHidden = false
                        self.nowLoadingActivity.stopAnimating()
                        
                    })
                    
                }
            }
            else
            {
                self.nowLoadingActivity.stopAnimating()
                self.BeverageTable.isHidden = false
            }
            
        })
        //end
    }

}
