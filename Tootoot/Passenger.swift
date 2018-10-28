//
//  Passenger.swift
//  Tootoot
//
//  Created by Aïmane Najja on 28/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit

class Passenger: NSObject {

    var name: String
    var location: String
    var destination: String
    
    init?(name: String, location: String, destination: String) {
        if name.isEmpty || location.isEmpty || destination.isEmpty {
            return nil
        }
        // The variables must not be empty
        guard !name.isEmpty || !location.isEmpty || !destination.isEmpty else {
                return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.location = location
        self.destination = destination
    }
    
}
