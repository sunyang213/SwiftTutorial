//
//  UtilityFunctions.swift
//  SwiftTutorial
//
//  Created by Chang on 3/7/15.
//  Copyright (c) 2015 Chang. All rights reserved.
//

import Foundation

/**
Creates a dictionary with an optional
entry for every element in an array.

Example:

struct Person
{
let name: String
let age:  Int
}

let people = [
Person(name: "Billy", age: 42),
Person(name: "David", age: 24),
Person(name: "Maria", age: 99)]

let dictionary = toDictionary(people) { ($0.name, $0.age) }

println(dictionary)
// Prints: [Billy: 42, David: 24, Maria: 99]

*/
func toDictionary<E, K, V>(
    array:       [E],
    transformer: (element: E) -> (key: K, value: V)?)
    -> Dictionary<K, V>
{
    return array.reduce([:]) {
        (var dict, e) in
        if let (key, value) = transformer(element: e)
        {
            dict[key] = value
        }
        return dict
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}

