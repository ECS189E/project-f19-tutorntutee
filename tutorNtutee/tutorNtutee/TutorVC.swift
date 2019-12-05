//
//  TutorVC.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/12/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import CoreLocation

class TutorVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var srcBar: UISearchBar!
    @IBOutlet weak var classTable: UITableView!
    
//    var closestBuilding = -1
    var isShowAll = false
    var isExpanded = false
    var closestClassSet = [String]()
    
    let hutchinson_array = ["ECS189E", "ECS050", "ECS122A", "NUT010", "UWP101", "MAT127A"]
    let giedt_array = ["ECS154A", "ECS153", "ECS171", "ECS020", "MAT022A", "MAT145"]
    let wellman_array = ["ECS036A", "ECS036B", "ECS036C", "MAT180", "MAT150A", "MAT021A", "MAT021B", "MAT021C", "MAT021D"]
    let haring_array = ["ECS150", "ECS189G", "MAT108", "MAT115A", "MAT118A", "MAT119A", "MAT127A", "MAT127B", "MAT127C"]
    
    let classArray = ["ECS020","ECS032A","ECS032B","ECS032C","ECS034","ECS036A","ECS036B","ECS036C","ECS050","ECS120","ECS122A","ECS122B","ECS132","ECS140A","ECS153","ECS154A","ECS160","ECS171","ECS175","ECS188","ECS189G","ECS150", "ECS189E", "MAT012","MAT016A","MAT016B","MAT016C","MAT017A", "MAT017B","MAT017C", "MAT021A", "MAT021B", "MAT021C", "MAT021D", "MAT022A", "MAT022B", "MAT108", "MAT115A", "MAT118A", "MAT119A", "MAT127A", "MAT127B", "MAT127C", "MAT128A","MAT135A", "MAT145", "MAT150A", "MAT167", "MAT168", "MAT180", "MAT185A", "UWP101", "NUT010"]
    var autofillArray = [String]()
    var isSearching = false
    let locationManager = CLLocationManager()
    var location : CLLocation?
    var nearestBuilding = -1
    var coordinatesArray = [CLLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        createCoordinates()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        startLocationManager()
        
        classTable.delegate = self
        classTable.dataSource = self
        classTable.allowsSelection = true
        
    }
    func createCoordinates() {
        let hutchison_coordinates = CLLocation(latitude: 38.541230,
                                               longitude: -121.753557)
        coordinatesArray.append(hutchison_coordinates)
        let giedt_coordinates = CLLocation(latitude: 38.537837,
        longitude: -121.755666)
        coordinatesArray.append(giedt_coordinates)
        let wellman_coordinates = CLLocation(latitude: 38.541351,
        longitude: -121.751413)
        coordinatesArray.append(wellman_coordinates)
        let haring_coordinates = CLLocation(latitude: 38.539707,
        longitude: -121.753408)
        coordinatesArray.append(haring_coordinates)
    }
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please, turn on your location services and try again", preferredStyle: .alert)
            let goAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(goAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    @IBAction func expandBtn(_ sender: Any) {
        if !isExpanded{
            self.isShowAll = true
            isExpanded = true
            chooseClassSet()
            classTable.reloadData()
        } else {
            chooseClassSet()
            isExpanded = false
        }
        
    }
    
    func chooseClassSet() {
        print("-----------------------------",nearestBuilding)
        if (isShowAll || nearestBuilding == -1){
       
            self.closestClassSet = classArray
            self.isShowAll = false
        } else {
            switch nearestBuilding {
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
        classTable.reloadData()
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
        self.present(dateVC,animated: true,completion: nil)
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
extension TutorVC: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("there is an error in retrieving the location:", error)
//        stopLocationManager()
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        
        guard let currLocation = location else{
            print("error in trying to unwrap location")
//            stopLocationManager()
            return
        }
        print(currLocation)
        print("latitude:", currLocation.coordinate.latitude)
        print("longitude:", currLocation.coordinate.longitude)
        
//        let test_coordinates = CLLocation(latitude: 38.544000, longitude: -121.758060)
        var counter = 0
        var selected = -1
        var shortestDistance = 9999999 as CLLocationDistance
         // result is in meters
        for new_coord in coordinatesArray {
            counter += 1
            let distanceInMeters = currLocation.distance(from: new_coord)
            print("******************************************************")
            print(distanceInMeters)
            if distanceInMeters < shortestDistance {
                shortestDistance = distanceInMeters
                selected = counter
            }
        }
        print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print(shortestDistance)
        print(selected)
        self.nearestBuilding = selected
        
        chooseClassSet()
        
        stopLocationManager()
    }
}

