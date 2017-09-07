//
//  CameraController.swift
//  cameraDemo
//
//  Created by Daniel Bacon on 9/1/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit
import AVFoundation


class CameraController: NSObject {
    
    // MARK: - Properties
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?

    var currentCameraPosition: CameraPosition?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var backCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?

    var photoOutput: AVCapturePhotoOutput?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var movieOutput: AVCaptureMovieFileOutput?
    var movieCaptureComletionBlock: ((URL?, Error?) -> Void)?
    
    var videoData = NSData()
    var maxDuration: CMTime?
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
    var fileMainURL: NSURL?
    
    var flashMode = AVCaptureFlashMode.off

    
    // MARK: - Error management
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    
    // MARK: - Camera positioning
    public enum CameraPosition {
        case front
        case rear
    }
    
    
    // MARK: - Prepare Function
    // Configure capture session.
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            // Find available devices
            let session = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
            guard let cameras = (session?.devices.flatMap { $0 }), !cameras.isEmpty else {
                throw CameraControllerError.noCamerasAvailable
            }
            
            // Loop through found devices
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.backCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            // Rear camera input
            if let rearCamera = self.backCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                }
                
                self.currentCameraPosition = .rear
            }
            
            // Front camera input
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) {
                    captureSession.addInput(self.frontCameraInput!)
                } else {

                    throw CameraControllerError.inputsAreInvalid
                }
                
                self.currentCameraPosition = .front
            } else {
                
                throw CameraControllerError.noCamerasAvailable
            }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            // Photo output
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput) {
                captureSession.addOutput(self.photoOutput)
            }
            
            captureSession.startRunning()
        }
        
        
        // Asynchronous block to call configuration functions
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    
    // MARK: - Preview layer setup
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    
    // MARK: - Switch camera position
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
                
            else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        func switchToRearCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                let rearCamera = self.backCamera else {
                    throw CameraControllerError.invalidOperation
            }
            
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
                
                self.currentCameraPosition = .rear
            }
                
            else { throw CameraControllerError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        
        captureSession.commitConfiguration()
    }
}


// MARK: - Extension for capturing images
extension CameraController: AVCapturePhotoCaptureDelegate {
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    
    public func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error {
            self.photoCaptureCompletionBlock?(nil, error)
        }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil), let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        } else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}


// MARK: - Configure output back to photo
extension CameraController {
    func switchToPhoto() {
        guard let captureSession = self.captureSession else {
            print(CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let outputs = captureSession.outputs as? [AVCaptureOutput]
        if outputs != nil {
            for output in outputs! {
                captureSession.removeOutput(output)
            }
        }
        
        if captureSession.canAddOutput(self.photoOutput) {
            captureSession.addOutput(self.photoOutput)
        }
        
        captureSession.startRunning()
    }
}


// MARK: - Configure output to video
extension CameraController {
    func configureVideoOutput() {
        guard let captureSession = self.captureSession else {
             print(CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let outputs = captureSession.outputs as? [AVCaptureOutput]
        if outputs != nil {
            for output in outputs! {
                captureSession.removeOutput(output)
            }
        }
        
        self.maxDuration = CMTimeMake(600, 10)
        self.fileMainURL = NSURL(string: ("\(self.documentsURL.appendingPathComponent("temp"))" + ".mov"))
        self.movieOutput = AVCaptureMovieFileOutput()
        self.movieOutput?.maxRecordedDuration = self.maxDuration!
        self.movieOutput?.minFreeDiskSpaceLimit = 1024 * 1024
        
        if captureSession.canAddOutput(self.movieOutput) {
            captureSession.addOutput(self.movieOutput)
        }
        
        captureSession.startRunning()
    }
}


// MARK: - Capture video
extension CameraController: AVCaptureFileOutputRecordingDelegate {
    func captureVideo() {
        guard let captureSession = captureSession, captureSession.isRunning else {
            print("Error: \(CameraControllerError.captureSessionIsMissing)")
            return
        }
        
        let settings = AVCapturePhotoSettings()
        let recordingDelegate: AVCaptureFileOutputRecordingDelegate? = self

        settings.flashMode = self.flashMode
        self.movieOutput?.startRecording(toOutputFileURL: self.fileMainURL as URL!, recordingDelegate: recordingDelegate)
    }
    
    
    func stopRecording(completion: @escaping (URL?, Error?) -> Void) {
        self.movieOutput?.stopRecording()
        self.movieCaptureComletionBlock = completion

    }
    
    
    public func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    }

    public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if let error = error {
            self.movieCaptureComletionBlock?(nil, error)
        }
            
        else if let url = outputFileURL {
            self.movieCaptureComletionBlock?(url, nil)
        } else {
            self.movieCaptureComletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}
