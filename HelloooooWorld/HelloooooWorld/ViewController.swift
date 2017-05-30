//
//  ViewController.swift
//  HelloooooWorld
//
//  Created by Daniel Bacon on 5/30/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var welcomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressed(_ sender: Any) {
        backGround.isHidden = false
        welcomeButton.isHidden = true
    }
}

