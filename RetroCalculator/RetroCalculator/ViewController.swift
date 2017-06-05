//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Daniel Bacon on 6/5/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    var btnSound: AVAudioPlayer!
    var currentOpperation = Operation.Empty
    var runningNumber = ""
    var leftVal = ""
    var rightVal = ""
    var result = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Bundle is the bundle of files for the app on a given device
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)

        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLabel.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton){
        playSound()
        
        // tags are set for each number(button) in the storyboard
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func dividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func multiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func subtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }

    @IBAction func equalPressed(sender: AnyObject) {
        processOperation(operation: currentOpperation)
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }

    func processOperation(operation: Operation) {
        playSound()
        
        if currentOpperation != Operation.Empty {
            
            //Check for number being pressed (not an operator) after an operator has been pressed
            if runningNumber != "" {
                rightVal = runningNumber
                runningNumber = ""
                
                if currentOpperation == Operation.Multiply {
                    result = "\(Double(leftVal)! * Double(rightVal)!)"
                } else if currentOpperation == Operation.Divide {
                    result = "\(Double(leftVal)! / Double(rightVal)!)"
                } else if currentOpperation == Operation.Add {
                    result = "\(Double(leftVal)! + Double(rightVal)!)"
                } else if currentOpperation == Operation.Subtract {
                    result = "\(Double(leftVal)! - Double(rightVal)!)"
                }
                leftVal = result
                outputLabel.text = leftVal
            }
            currentOpperation = operation
        } else {

            //First time an operator has been pressed
            leftVal = runningNumber
            runningNumber = ""
            currentOpperation = operation
        }
    }
}

