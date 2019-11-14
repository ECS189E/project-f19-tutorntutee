//
//  DateVC.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/12/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class DateVC: UIViewController {
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var tilTimeTextField: UITextField!
    
    var selectedClass = ""
    
    private var datePicker : UIDatePicker?
    private var timePicker : UIDatePicker?
    private var tilTimePicker : UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
