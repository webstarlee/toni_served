//
//  MenuMakeController.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MenuMakeController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddFoodDelegate,AddKindDelegate,EditFoodDelegate {

    @IBOutlet weak var MenuTable: UITableView!
    
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
        
        MenuTable.delegate = self
        MenuTable.dataSource = self
        MenuTable.isHidden = true
        
        ref = Database.database().reference()
        
        self.ref?.child("menu_kind").child(self.restarantId).observeSingleEvent(of: .value, with: { (snapshot_kind) in
            
            let res_kind_check = snapshot_kind.value as? [String: Any]
            
            if res_kind_check != nil
            {
                for (key, val) in res_kind_check!{
                    
                    var food_kind : String = ""
                    
                    var food_key : String = ""
                    
                    var food_list = [Dictionary<String,String>]()
                    
                    food_kind = val as! String
                    food_key = key
                    
                    self.ref?.child("menu_food").child(self.restarantId).child(key).observeSingleEvent(of: .value, with: { (snapshot_food) in
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
                        
                        self.MenuTable.reloadData()
                        
                        self.MenuTable.isHidden = false
                        
                        self.nowLoadingActivity.stopAnimating()
                        
                    })
                    
                }
            }
            else{
                self.MenuTable.isHidden = false
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
        var cell = MenuTable.dequeueReusableCell(withIdentifier: "cellFood") as! HostMenuTableCell
        
        if indexPath.row < objectsArray[indexPath.section].list.count
        {
            //cell texts define
            cell.cellFoodName.text = objectsArray[indexPath.section].list[indexPath.row]["title"]?.uppercased()
            cell.cellFoodMaterial.text = objectsArray[indexPath.section].list[indexPath.row]["body"]?.uppercased()
            cell.cellFoodPrice.text = objectsArray[indexPath.section].list[indexPath.row]["price"]!
        }else if indexPath.row == objectsArray[indexPath.section].list.count
        {
            //when last cell for make add new food button
            cell = MenuTable.dequeueReusableCell(withIdentifier: "addNewFood")! as! HostMenuTableCell
        }
        
        return cell
    }
    //end
    
    //tableview header define
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //general header
        var header = MenuTable.dequeueReusableCell(withIdentifier: "headerKind") as! HostMenuTableCell
        
        if section < objectsArray.count
        {
            //header text define
            header.headerKindLabel.text = objectsArray[section].kind.uppercased()
        }else if section == objectsArray.count
        {
            //when last make kind add button
            header = MenuTable.dequeueReusableCell(withIdentifier: "addNewKind") as! HostMenuTableCell
        }
        
        return header
    }
    //end
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    //when clicking the table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        MenuTable.deselectRow(at: indexPath, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if indexPath.row < objectsArray[indexPath.section].list.count
        {
            let editFoodController = storyBoard.instantiateViewController(withIdentifier: "EditFood") as! EditFoodController
            
            editFoodController.delegate = self;
            
            editFoodController.set_food_kind = objectsArray[indexPath.section].kind
            editFoodController.set_food_name = objectsArray[indexPath.section].list[indexPath.row]["title"]!
            editFoodController.set_food_material = objectsArray[indexPath.section].list[indexPath.row]["body"]!
            editFoodController.set_food_price = objectsArray[indexPath.section].list[indexPath.row]["price"]!
            editFoodController.set_food_kind_key = objectsArray[indexPath.section].key
            editFoodController.set_food_key = objectsArray[indexPath.section].list[indexPath.row]["food_key"]!
            
            //make popup
            editFoodController.modalPresentationStyle = .overCurrentContext
            editFoodController.modalTransitionStyle = .crossDissolve
            present(editFoodController, animated: true, completion: nil)
            //end
        }
        
        if indexPath.row == objectsArray[indexPath.section].list.count
        {
            
            let addFoodController = storyBoard.instantiateViewController(withIdentifier: "AddFood") as! AddFoodController
            
            //delegate to self for reload data when dismiss popup
            addFoodController.delegate = self;
            
            //define menu kind for add new food
            addFoodController.Food_Kind_Name = objectsArray[indexPath.section].kind!
            addFoodController.Food_Kind_Key = objectsArray[indexPath.section].key!
            
            //make popup
            addFoodController.modalPresentationStyle = .overCurrentContext
            addFoodController.modalTransitionStyle = .crossDissolve
            present(addFoodController, animated: true, completion: nil)
            //end
        }
    }
    //end
    
    @IBAction func Add_NewKind(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addFoodKindController = storyBoard.instantiateViewController(withIdentifier: "AddFoodKind") as! AddFoodKindController
        
        addFoodKindController.delegate = self;
        
        addFoodKindController.modalPresentationStyle = .overCurrentContext
        addFoodKindController.modalTransitionStyle = .crossDissolve
        present(addFoodKindController, animated: true, completion: nil)
    }
    
    
    func addedNewFood() {
        
        self.MenuTable.isHidden = true
        self.nowLoadingActivity.startAnimating()
        
        //define obkectArray to nil again
        objectsArray = [Objects]()
        
        
        //reload all data
        self.ref?.child("menu_kind").child(Singletone.restaurant_id).observeSingleEvent(of: .value, with: { (snapshot_kind) in
            
            let res_kind_check = snapshot_kind.value as? [String: Any]
            
            if res_kind_check != nil
            {
                for (key, val) in res_kind_check!{
                    
                    var food_kind : String = ""
                    
                    var food_key : String = ""
                    
                    var food_list = [Dictionary<String,String>]()
                    
                    food_kind = val as! String
                    food_key = key
                    
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
                        
                        self.objectsArray.append(Objects(kind: food_kind,key: food_key, list:food_list))
                        
                        self.MenuTable.reloadData()
                        self.MenuTable.isHidden = false
                        self.nowLoadingActivity.stopAnimating()
                        
                    })
                    
                }
            }
            else
            {
                self.nowLoadingActivity.stopAnimating()
                self.MenuTable.isHidden = false
            }
            
        })
        //end
    }
    

}
