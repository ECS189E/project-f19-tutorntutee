//
//  DateVC.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/12/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

class DateVC: UIViewController{
    
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var tilTimeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var deleteText: UITextField!
    
    var selectedClass = ""
    
    private var datePicker : UIDatePicker?
    private var timePicker : UIDatePicker?
    private var tilTimePicker : UIDatePicker?
    var ref: DatabaseReference!
    var postsRef: DatabaseReference!
    var updateRef: DatabaseReference!
    var updatePostsRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the current user id
        let userID = Auth.auth().currentUser?.uid
        updatePostsRef=Database.database().reference()
        postsRef = Database.database().reference().child("posts")
        // go to the node where class_time is stored
        ref = Database.database().reference().child("user").child(userID ?? "error with userID").child("tutor_class_time")
        updateRef = Database.database().reference().child("user").child(userID ?? "error with userID")
        print("check userID -->", userID ?? "error in getting userID !!!")
        
        // Do any additional setup after loading the view.
        classLabel.text = selectedClass
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = Date()
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        tilTimePicker = UIDatePicker()
        tilTimePicker?.datePickerMode = .time
        
        timePicker?.addTarget(self, action: #selector(DateVC.timeChanged(timePicker:)), for: .valueChanged)
        
        tilTimePicker?.addTarget(self, action: #selector(DateVC.tilTimeChanged(tilTimePicker:)), for: .valueChanged)
        
        datePicker?.addTarget(self, action: #selector(DateVC.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DateVC.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        timeTextField.inputView = timePicker
        dateTextField.inputView = datePicker
        tilTimeTextField.inputView = tilTimePicker
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        guard let sTime = timeTextField.text, (timeTextField.text ?? "") != ""  else {
            let errorMessage=UIAlertController(title: "Invalid Start Time", message: "End time has an error", preferredStyle: .alert)
            let close = UIAlertAction(title:"OK",style: .cancel,handler: nil)
            errorMessage.addAction(close)
            self.present(errorMessage,animated: true,completion: nil)
            
            return
        }
        guard let eTime = tilTimeTextField.text, (tilTimeTextField.text ?? "") != ""  else {
            let errorMessage=UIAlertController(title: "Invalid End Time", message: "End time has an error", preferredStyle: .alert)
            let close = UIAlertAction(title:"OK",style: .cancel,handler: nil)
            errorMessage.addAction(close)
            self.present(errorMessage,animated: true,completion: nil)
            return
        }
        guard let d = dateTextField.text, (dateTextField.text ?? "") != ""  else {
            let errorMessage=UIAlertController(title: "Invalid Date", message: "Date has an error", preferredStyle: .alert)
            let close = UIAlertAction(title:"OK",style: .cancel,handler: nil)
            errorMessage.addAction(close)
            self.present(errorMessage,animated: true,completion: nil)
            return
        }
        guard let p = priceTextField.text, (priceTextField.text ?? "") != ""  else {
            let errorMessage=UIAlertController(title: "Invalid Price", message: "Price has an error", preferredStyle: .alert)
            let close = UIAlertAction(title:"OK",style: .cancel,handler: nil)
            errorMessage.addAction(close)
            self.present(errorMessage,animated: true,completion: nil)
            return
        }
        
        let startTime = sTime.replacingOccurrences(of: " ", with: "")
        let endTime = eTime.replacingOccurrences(of: " ", with: "")
        let myDate = d.replacingOccurrences(of: " ", with: "")
        let myPrice = p.replacingOccurrences(of: " ", with: "")
        let userID = Auth.auth().currentUser?.uid
        let newSchedule = "\(userID ?? "V45TFWp0ahU0OfX8Kp5FPwxpvQA3") \(selectedClass) \(myDate) \(startTime) \(endTime) $\(myPrice)"
        print(newSchedule)
        addNewSchedule(newSchedule: newSchedule)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = storyboard.instantiateViewController(identifier: "MenuInitView")
        let navControllerVC = vs as! UITabBarController
        navControllerVC.modalPresentationStyle = .fullScreen
        self.present(navControllerVC, animated: true, completion: nil)
    }
    
    func addNewSchedule(newSchedule: String) {
        
        var scheduleArray = [String]()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            // Get user value
            //            let value = snapshot.value as? NSDictionary
            let scheduleDB = snapshot.value as? NSArray
            //            guard let val = snapshot.value else {
            //                print("error in getting snapshot.value")
            //                return
            //            }
            
            for oneSchedule in scheduleDB ?? ["error in getting the nsarray elements"] {
                let exisitingSchedule = oneSchedule as! String
                
                // check if the chedule already exist in the databse
                if newSchedule.isEqual(exisitingSchedule) {
                    print("the schedule already exists in the database")
                    let errorMessage=UIAlertController(title: "error", message: "the schedule already exists in the database", preferredStyle: .alert)
                    let close = UIAlertAction(title:"close",style: .cancel,handler: nil)
                    errorMessage.addAction(close)
                    self.present(errorMessage,animated: true,completion: nil)
                    return
                }
                print(exisitingSchedule)
                scheduleArray.append(exisitingSchedule)
                
            }
            scheduleArray.append(newSchedule)
            self.updateRef.updateChildValues(["tutor_class_time":scheduleArray])
            
            //          let sss = scheduleDB?[0] as? String ?? "error in the class"
            //          print("sss -->", sss)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        var newPostsArray = [String]()
        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()){
                let postsArray = snapshot.value as? NSArray
                print("exists!", postsArray ?? ["error in parsing posts"])
                for onePost in  postsArray ?? ["error in parsing posts"] {
                    let exisitingPost = onePost as! String
                    if newSchedule.isEqual(exisitingPost) {
                        return
                    }
                    newPostsArray.append(exisitingPost)
                }
                newPostsArray.append(newSchedule)
                self.updatePostsRef.updateChildValues(["posts":newPostsArray])
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    //    @IBAction func deleteBtn(_ sender: Any) {
    //        print("delete clicked")
    //        deleteSelectedSchedule(deleteSchedule: deleteText.text ?? "")
    //    }
    //
    func deleteSelectedSchedule(deleteSchedule : String) {
        var scheduleArray2 = [String]()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            
            //            let value = snapshot.value as? NSDictionary
            let scheduleDB = snapshot.value as? NSArray
            //            guard let val = snapshot.value else {
            //                print("error in getting snapshot.value")
            //                return
            //            }
            
            for oneSchedule in scheduleDB ?? ["error in getting the nsarray elements"] {
                let dbSchedule = oneSchedule as! String
                
                // check if the chedule already exist in the databse
                if deleteSchedule.isEqual(dbSchedule) {
                    print("removed from local database: \(dbSchedule)")
                    continue
                }
                scheduleArray2.append(dbSchedule)
                
            }
            self.updateRef.updateChildValues(["tutor_class_time":scheduleArray2])
            
            //          let sss = scheduleDB?[0] as? String ?? "error in the class"
            //          print("sss -->", sss)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //        let oldPost = onePost as! String
        //        if deleteSchedule.isEqual(oldPost) {
        //            continue
        //        }
        
        var newPostsArray = [String]()
        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()){
                let postsArray = snapshot.value as? NSArray
                print("exists!", postsArray ?? ["error in parsing posts"])
                for onePost in  postsArray ?? ["error in parsing posts"] {
                    let oldPost = onePost as! String
                    if deleteSchedule.isEqual(oldPost) {
                        print("removed from global database: \(oldPost)")
                        continue
                    }
                    
                    newPostsArray.append(oldPost)
                }
                self.updatePostsRef.updateChildValues(["posts":newPostsArray])
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    @objc func tilTimeChanged(tilTimePicker: UIDatePicker) {
        print("tilTimeChanged")
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let _time = timeFormatter.string(from: tilTimePicker.date)
        tilTimeTextField.text = _time
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        print("dateChanged")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateTextField.text = date
    }
    
    @objc func timeChanged(timePicker: UIDatePicker) {
        print("timeChanged")
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let _time = timeFormatter.string(from: timePicker.date)
        timeTextField.text = _time
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        print("viewTapped")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
