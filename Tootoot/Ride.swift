//
//  Ride.swift
//  Tootoot
//
//  Created by Aïmane Najja on 23/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit

class Ride: NSObject {
    
    var distance: String
    var startTime: String
    var destination: String
    var seats: String
    
    init?(distance: String, startTime: String, destination: String, seats: String) {
        // Initialization should fail if there is no name or if the rating is negative.
        if distance.isEmpty || startTime.isEmpty || destination.isEmpty || seats.isEmpty  {
            return nil
        }
        // The variables must not be empty
        guard !distance.isEmpty || !startTime.isEmpty || !destination.isEmpty || !seats.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.distance = distance
        self.startTime = startTime
        self.destination = destination
        self.seats = seats
    }
    
    

}
