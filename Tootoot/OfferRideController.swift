//
//  OfferRideController.swift
//  Tootoot
//
//  Created by dervis kiratli on 22/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class OfferRideController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var carTextField: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var comments: UITextView!
    var ref: DatabaseReference!
    var startTime : String = ""
    var endTime: String = ""
    let locationManager = CLLocationManager()
    var locLat : Double = 0
    var locLong : Double = 0
    var location = CLLocation(latitude: 0, longitude: 0)
    var address: String = ""
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            
        }
        
        let location = CLLocation(latitude: locLat, longitude: locLong)
        
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
    }
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locLong = locValue.longitude
        locLat = locValue.latitude
        location = CLLocation(latitude: locLat, longitude: locLong)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    
    @IBAction func startTimeChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        startTime = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func endTimeChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        endTime = dateFormatter.string(from: sender.date)
    }
    @IBAction func placeRide(_ sender: UIButton) {

      
        
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let endLocation = self.endLocation.text
                let car = self.carTextField.text
                let comments = self.comments.text
                locationManager.requestLocation()
                self.ref.child("rides").child(uid).setValue(["endLocation":endLocation, "endTime": endTime,"startTime": startTime,"car":car,"comments":comments, "Longitude": locLong, "Latitude": locLat, "address": address])
                
            }
        }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            address = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                address = placemark.compactAddress ?? "default value"
            } else {
                address = "No Matching Addresses Found"
            }
        }
        
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

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}

