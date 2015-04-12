//
//  ViewController_BrandPage.swift
//  SwiftTutorial
//
//  Created by Chang on 3/19/15.
//  Copyright (c) 2015 Chang. All rights reserved.
//

import UIKit

class ViewController_BrandPage: UIViewController, UITextFieldDelegate {
    
    var selectedBrandId: String = ""
//    @IBOutlet var ResultLable: UILabel! = nil
//    @IBOutlet var BrandId: UITextField!
//    @IBOutlet var BatchCode: UITextField!
    @IBOutlet var ResultLable: UILabel!
    @IBOutlet var BatchCode: UITextField!

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func CheckDate(sender: AnyObject) {
        
        self.ResultLable.text = ""
        var decodedDate: String!
        //println("BrandId: \(selectedBrandId), BatchCode: \(BatchCode.text)")
        
        /*
        // dataTaskWithURL will send GET request
        // dataTaskWithRequest will send POST request
        */
        
        
        //        /* Http GET 1 */
        //        let url = NSURL(string: "https://testcosmetics.azure-mobile.net/api/testapi?brandid=105&batchcode=d89")
        //
        //        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        //            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        //        }
        //
        //        task.resume()
        //        // Above example works
        
        
        /* HTTP POST 2 */
        var request = NSMutableURLRequest(URL: NSURL(string: "https://cosmetics-test.azure-mobile.net/api/test")!)
        // request API.
        var params = ["brandid":"\(selectedBrandId)","batchcode":"\(BatchCode.text)"]
        println(params)
        
        // request parameters
        var err: NSError?
        // request returns error
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        // This Line fills the web service with required parameters.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler:
            {data, response, error -> Void in
                //var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                //println("stringData: \(strData)")
                
                //var err1: NSError?
                //var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err1 ) as NSDictionary
                var jsonTest = JSON(data:data)
                let date = jsonTest[0]["DecodedDate"].string!
                decodedDate = date
                
                if((error) != nil) {
                    println(err!.localizedDescription)
                }
                else {
                    var success = "success"
                    println("Succes: \(success)")
                    println("jsonData->Date : \(date)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        //perform all UI stuff here
                        self.ResultLable.text = decodedDate
                    })
                }
        })
        
        task.resume()
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(String(selectedBrandId))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

