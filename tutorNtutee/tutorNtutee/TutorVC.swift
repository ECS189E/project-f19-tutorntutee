//
//  TutorVC.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/12/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit

class TutorVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var srcBar: UISearchBar!
    @IBOutlet weak var classTable: UITableView!
    
    let classArray = ["ECS150", "ECS189E", "ESS","UWP101", "NUT10", "MATH108", "UWP104"]
    var autofillArray = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classTable.delegate = self
        classTable.dataSource = self
        classTable.allowsSelection = true

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return autofillArray.count
        } else {
            return classArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = classTable.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "accountCell")
        if isSearching {
            cell.textLabel?.text = autofillArray[indexPath.row]
        } else {
            cell.textLabel?.text = classArray[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClass = self.classArray[indexPath.row]
        print(selectedClass)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DateVC")
        let dateVC = vc as! DateVC
        dateVC.selectedClass = selectedClass
        self.navigationController?.pushViewController(dateVC, animated: true)
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

extension TutorVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        autofillArray = classArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        classTable.reloadData()
        
    }
}
