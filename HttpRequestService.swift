//
//  HttpRequestService.swift
//  SwiftTutorial
//
//  Created by Chang on 3/5/15.
//  Copyright (c) 2015 Chang. All rights reserved.
//

import Foundation

/***************************************************************************************
**** Help Document
**** dataTaskWithURL will send GET request
**** dataTaskWithRequest will send POST request
***************************************************************************************/

/***************************************************************************************
**** HTTP GET with JSON format paramter
**** Need SwiftyJSON.swift library support
**** Parameter: request url and request parameters
**** Return: error and result
**** How to call function:
let requestResponse = sendJSONHttpPost(url, param)
**** How to deal with return values:
if((requestResponse.error) != nil) { println(requestResponse.error!.localizedDescription) }
else { var jsonData = JSON(data:requestResponse.result)
let success = jsonData[0]["success"].bool!
}
***************************************************************************************/
func sendJSONHttpGet(url:String, param:String) -> (NSError?, NSData?)
{
    var returnError: NSError?
    var returnData: NSData?
    
    let requestUrl = NSURL(string: url)
    let task = NSURLSession.sharedSession().dataTaskWithURL(requestUrl!) {
        (data, response, error) in
        //println(NSString(data: data, encoding: NSUTF8StringEncoding))
        returnError = error
        returnData = data
    }
    task.resume()
    return (returnError, returnData)
}

/***************************************************************************************
**** HTTP POST with JSON format paramter
**** Need SwiftyJSON.swift library support
**** Parameter: request url and request parameters
**** Return: error and result
**** How to call function:
        let requestResponse = sendJSONHttpPost(url, param)
**** How to deal with return values: 
        if((requestResponse.error) != nil) { println(requestResponse.error!.localizedDescription) }
        else { var jsonData = JSON(data:requestResponse.result) 
               let success = jsonData[0]["success"].bool!
        }
***************************************************************************************/
func sendJSONHttpPost(url:String, param:String) -> (error: NSError?, result: NSData?)
{
    var returnError: NSError?
    var returnData: NSData?

    var request = NSMutableURLRequest(URL: NSURL(string: url)!) // request API
    var session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    // Fills the web service with required parameters.
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: &returnError)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        returnError = error
        returnData = data
    })
    
    task.resume()
    return (returnError, returnData)
}

