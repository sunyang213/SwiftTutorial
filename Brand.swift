//
//  Brand.swift
//  SwiftTutorial
//
//  Created by Chang on 3/7/15.
//  Copyright (c) 2015 Chang. All rights reserved.
//

import Foundation

class Brand{
    let Key: String
    let Name: String
    let Section: Character
    
    init(key:String, name: String){
        self.Key = key
        self.Name = name
        self.Section = name.capitalizedString[0]
    }
    
    func getAllBrands(dict: Dictionary<String, String>) -> [Brand]{
        var returnArray: [Brand] = [Brand]()
        for (key:String, value: String) in dict{
            returnArray.append(Brand(key: key, name: value))
        }
        return returnArray
    }
}