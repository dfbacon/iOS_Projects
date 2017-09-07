//
//  CameraViewController.swift
//  cameraDemo
//
//  Created by Daniel Bacon on 9/1/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet fileprivate var capturePreviewView: UIView!
    @IBOutlet fileprivate var captureButton: UIButton!
    @IBOutlet fileprivate var flashToggleButton: UIButton!
    @IBOutlet fileprivate var cameraToggleButton: UIButton!
    @IBOutlet fileprivate var photoModeButton: UIButton!
    @IBOutlet fileprivate var videoModeButton: UIButton!
    
    // MARK: - Properties
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let cameraController = CameraController()
    var isVideo = false
    var isRecording = false
    
    override func viewDidLoad() {
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        
        func styleCaptureButton() {
            captureButton.layer.borderColor = UIColor.black.cgColor
            captureButton.layer.borderWidth = 2
            
            captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        }
        
        styleCaptureButton()
        configureCameraController()
    }
    
    
    @IBAction func toggleFlash(_ sender: Any) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            flashToggleButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            flashToggleButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    
    @IBAction func swapCamera(_ sender: Any) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            cameraToggleButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            
        case .some(.rear):
            cameraToggleButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            
        case .none:
            return
        }
    }
    

    @IBAction func switchToVideo(_ sender: Any) {
        self.isVideo = true
        cameraController.configureVideoOutput()
    }
    
    
    @IBAction func switchToPhoto(_ sender: Any) {
        self.isVideo = false
        cameraController.switchToPhoto()
    }
    
    
    @IBAction func captureImage(_ sender: Any) {
        if self.isVideo {
            
            if self.isRecording {
                self.isRecording = false
                cameraController.stopRecording {(url, error) in
                    guard let url = url else {
                        print(error ?? "Recording capture error")
                        return
                    }
                    
                    try? PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                    }
                }
                
            } else {
                self.isRecording = true
                cameraController.captureVideo()
            }

        } else {
            cameraController.captureImage {(image, error) in
                guard let image = image else {
                    print(error ?? "Image capture error")
                    return
                }
            
                try? PHPhotoLibrary.shared().performChangesAndWait {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
            }
        }
    }
    
}

