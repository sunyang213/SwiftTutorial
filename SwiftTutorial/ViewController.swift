//
//  ViewController.swift
//  SwiftTutorial
//
//  Created by Chang on 2/16/15.
//  Copyright (c) 2015 Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var firstCardImageView: UIImageView!
    @IBOutlet weak var secondCardImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        println("load")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func playButtonClick(sender: UIButton) {
        
        var firstCard : Int32 = rand() % 13 + 1
        var secondCard : Int32 = rand() % 13 + 1
        
        self.firstCardImageView.image = UIImage (named: "card" + String(firstCard))
        self.secondCardImageView.image = UIImage(named: "card" + String(secondCard))
        
        // Add record into .plist file

        
        //data.writeToFile(path, atomically: true)
    }
}

