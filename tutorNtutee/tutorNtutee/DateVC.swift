//
//  DateVC.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/12/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import Firebase

class DateVC: UIViewController {
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var tilTimeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var selectedClass = ""
    
    private var datePicker : UIDatePicker?
    private var timePicker : UIDatePicker?
    private var tilTimePicker : UIDatePicker?
    var ref: DatabaseReference!
    var updateRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the current user id
        let userID = Auth.auth().currentUser?.uid
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
            print("start time has an error")
            return
        }
        guard let eTime = tilTimeTextField.text, (tilTimeTextField.text ?? "") != ""  else {
            print("end time has an error")
            return
        }
        guard let d = dateTextField.text, (dateTextField.text ?? "") != ""  else {
            print("date has an error")
            return
        }
        guard let p = priceTextField.text, (priceTextField.text ?? "") != ""  else {
            print("price has an error")
            return
        }
        let startTime = sTime.replacingOccurrences(of: " ", with: "")
        let endTime = eTime.replacingOccurrences(of: " ", with: "")
        let myDate = d.replacingOccurrences(of: " ", with: "")
        let myPrice = p.replacingOccurrences(of: " ", with: "")
        
        let newSchedule = "\(selectedClass) \(myDate) \(startTime) \(endTime) $\(myPrice)"
        
        print(newSchedule)
        
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
                print("----------------------------")
                
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
