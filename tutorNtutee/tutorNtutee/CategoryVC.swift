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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tutorBtn(_ sender: Any) {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        startLocationManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "searchID")
        let push = vc as! TutorVC
        self.navigationController?.pushViewController(push, animated: true)
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
        }
        
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
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

extension CategoryVC : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("there is an error in retrieving the location:", error)
//        stopLocationManager()
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        print(location)
        guard let currLocation = location else{
            print("error in trying to unwrap location")
            stopLocationManager()
            return
        }
        print("latitude:", currLocation.coordinate.latitude)
        print("longitude:", currLocation.coordinate.longitude)
        stopLocationManager()
    }
}
