//
//  Ride.swift
//  Tootoot
//
//  Created by Aïmane Najja on 23/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit

class Ride: NSObject {
    
    var driver: String
    var car: String
    var beginLocation: String
    var destination: String
    var startTime: String
    var seats: String
    var comments: String
    
    init?(driver: String, car: String, beginLocation: String,
          destination: String, startTime: String,  seats: String, comments: String) {
        // Initialization should fail if there is no name or if the rating is negative.
        if driver.isEmpty || car.isEmpty || beginLocation.isEmpty ||
            destination.isEmpty || startTime.isEmpty || seats.isEmpty || comments.isEmpty  {
            return nil
        }
        // The variables must not be empty
        guard !driver.isEmpty || !car.isEmpty || !beginLocation.isEmpty ||
            !destination.isEmpty || !startTime.isEmpty || !seats.isEmpty || !comments.isEmpty else {
                return nil
        }
        
        // Initialize stored properties.
        self.driver = driver
        self.car = car
        self.beginLocation = beginLocation
        self.destination = destination
        self.startTime = startTime
        self.seats = seats
        self.comments = comments
    }
    
    
    
}
