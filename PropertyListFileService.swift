//
//  PropertyListFileService.swift
//  SwiftTutorial
//
//  Created by Chang on 3/5/15.
//  Copyright (c) 2015 Chang. All rights reserved.
//

import Foundation

/*
Example: Read/Write to .plist
deleteLocalPropertyListFile("data")
let myDict = loadPropertyListFile("data")
myDict.setObject("testValue", forKey: "testKey")
saveLocalPropertyListFile("data", myDict)
println(loadPropertyListFile("data"))
*/

// Get local .plist path by name
func getLocalPropertyListFilePath(filename: String)->String{
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    let documentsDirectory = paths[0] as String
    let path = documentsDirectory.stringByAppendingPathComponent("\(filename).plist")
    return path
}

// Get default bundle .plist path by name
func getDefaultBundlePropertyListFilePath(filename: String)->String{
    if let bundlePath = NSBundle.mainBundle().pathForResource("\(filename)", ofType: "plist"){
        return bundlePath
    }
    else {
        return "Failed"
    }
}

// Load local .plist path into a dict
func loadPropertyListFile(filename: String)->NSMutableDictionary{
    // Get local plist path
    let path = getLocalPropertyListFilePath(filename)
    let fileManager = NSFileManager.defaultManager()
    // If local plist file does not exist, load from bundle default
    if(!fileManager.fileExistsAtPath(path)) {
        // Get default bundle plist path
        println("\(filename).plist does not exist, try to load from default bundle")
        let bundlePath = getDefaultBundlePropertyListFilePath(filename)
        if(fileManager.fileExistsAtPath(bundlePath)) {
            // Read from default bundle plist
            let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
            println("Bundle \(filename).plist file is --> \(resultDictionary?.description)")
            // Create local plist from default bundle
            fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
            // Return
            return resultDictionary!
        }
        else {
            println("Cannot find \(filename).plist. Please, make sure it is part of the bundle.")
            return NSMutableDictionary()
        }
    }
        // If local plist exists
    else {
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        //println("Loaded \(filename).plist file is --> \(resultDictionary?.description)")
        return resultDictionary!
    }
}

// Delete local plist file by name
func deleteLocalPropertyListFile(filename: String){
    let path = getLocalPropertyListFilePath(filename)
    let fileManager = NSFileManager.defaultManager()
    if(fileManager.fileExistsAtPath(path)) {
        fileManager.removeItemAtPath(path, error: nil)
    }
}

// Save changes to local plist
func saveLocalPropertyListFile(filename: String, dict: NSMutableDictionary)->Bool{
    let path = getLocalPropertyListFilePath(filename)
    let fileManager = NSFileManager.defaultManager()
    if(fileManager.fileExistsAtPath(path)) {
        // If plist exists
        dict.writeToFile(path, atomically: true)
        //println("Updated \(filename).plist file is --> \(dict.description)")
        return true
    }
    return false
}
