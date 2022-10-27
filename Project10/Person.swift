//
//  Person.swift
//  Project10
//
//  Created by RqwerKnot on 15/10/2022.
//

import UIKit

class Person: NSObject {
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    var name: String
    var image: String
}
