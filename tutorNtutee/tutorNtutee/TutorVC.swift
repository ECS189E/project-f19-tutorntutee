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
    
    var closestBuilding = -1
    var isShowAll = false
    var closestClassSet = [String]()
    
    let hutchinson_array = ["ECS189E", "ECS050", "ECS122A", "NUT010", "UWP101", "MAT127A"]
    let giedt_array = ["ECS154A", "ECS153", "ECS171", "ECS020", "MAT022A", "MAT145"]
    let wellman_array = ["ECS036A", "ECS036B", "ECS036C", "MAT180", "MAT150A", "MAT021A", "MAT021B", "MAT021C", "MAT021D"]
    let haring_array = ["ECS150", "ECS189G", "MAT108", "MAT115A", "MAT118A", "MAT119A", "MAT127A", "MAT127B", "MAT127C"]
    
    let classArray = ["ECS020","ECS032A","ECS032B","ECS032C","ECS034","ECS036A","ECS036B","ECS036C","ECS050","ECS120","ECS122A","ECS122B","ECS132","ECS140A","ECS153","ECS154A","ECS160","ECS171","ECS175","ECS188","ECS189G","ECS150", "ECS189E", "MAT012","MAT016A","MAT016B","MAT016C","MAT017A", "MAT017B","MAT017C", "MAT021A", "MAT021B", "MAT021C", "MAT021D", "MAT022A", "MAT022B", "MAT108", "MAT115A", "MAT118A", "MAT119A", "MAT127A", "MAT127B", "MAT127C", "MAT128A","MAT135A", "MAT145", "MAT150A", "MAT167", "MAT168", "MAT180", "MAT185A", "UWP101", "NUT010"]
    var autofillArray = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseClassSet()
        classTable.delegate = self
        classTable.dataSource = self
        classTable.allowsSelection = true
    }
    
    @IBAction func expandBtn(_ sender: Any) {
        self.isShowAll = true
        chooseClassSet()
        classTable.reloadData()
    }
    
    func chooseClassSet() {
        if (isShowAll || closestBuilding == -1){
            self.closestClassSet = classArray
            self.isShowAll = false
        } else {
            switch closestBuilding {
            case 1:
                self.closestClassSet = self.hutchinson_array
                break
            case 2:
                self.closestClassSet = self.giedt_array
                break
            case 3:
                self.closestClassSet = self.wellman_array
                break
            case 4:
                self.closestClassSet = self.haring_array
                break
            default:
                print("error in choosing the nearest class set!!!")
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return autofillArray.count
        } else {
            return closestClassSet.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = classTable.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "accountCell")
        if isSearching {
            cell.textLabel?.text = autofillArray[indexPath.row]
        } else {
            cell.textLabel?.text = closestClassSet[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClass = self.closestClassSet[indexPath.row]
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
        autofillArray = closestClassSet.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        classTable.reloadData()
    }
}
