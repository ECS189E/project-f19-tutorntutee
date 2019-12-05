//
//  CategoryVC.swift
//  tutorNtutee
//
//  Created by Alessandro on 11/28/19.
//  Copyright © 2019 Alessandro Liu. All rights reserved.
//

import UIKit
import CoreLocation

class CategoryVC: UIViewController {
    
    let locationManager = CLLocationManager()
    var location : CLLocation?
    var nearestBuilding = -1
    var coordinatesArray = [CLLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createCoordinates()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        startLocationManager()
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
    
    @IBAction func tutorBtn(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "searchID")
//        let push = vc as! TutorVC
//        push.closestBuilding = self.nearestBuilding
//        self.navigationController?.pushViewController(push, animated: true)
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
    
//    func stopLocationManager() {
//        locationManager.stopUpdatingLocation()
//        locationManager.delegate = nil
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoryVC : CLLocationManagerDelegate {
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
//        stopLocationManager()
    }
}
