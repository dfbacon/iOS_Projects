//
//  ViewController.swift
//  DevChat
//
//  Created by Daniel Bacon on 6/20/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class CameraVC: AAPLCameraViewController {

    @IBOutlet weak var previewView: AAPLPreviewView!
    
    override func viewDidLoad() {
        // Sync to _previewView running under the hood
        self._previewView = previewView
        
        super.viewDidLoad()
    }


}

