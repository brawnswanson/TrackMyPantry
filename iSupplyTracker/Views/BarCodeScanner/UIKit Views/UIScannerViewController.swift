//
//  UIScannerViewController.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 24.03.22.
//

import Foundation
import UIKit
import AVFoundation

class UIScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   
    @IBOutlet weak var previewView: PreviewView!
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue")
    private let metaDataOutput = AVCaptureMetadataOutput()
    private let metaDataObjectsQueue = DispatchQueue(label: "metadata object queue")
    var delegate: UIScannerViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView.session = session
    
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .denied:
            self.setupResult = .notAuthorized
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        case .restricted:
            self.setupResult = .notAuthorized
        @unknown default:
            fatalError()
        }
        
        sessionQueue.async {
            self.configureSession()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
            case .notAuthorized:
                print("not authorized")
            case .configurationFailed:
                print("configuration failed")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view will disappear")
        sessionQueue.async {
            if self.setupResult == .success {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
            }
        }
        super.viewWillDisappear(animated)
    }
    
    
    
    var videoDeviceInput: AVCaptureInput!
    
    func configureSession() {
        
        session.beginConfiguration()
        do {
            let defaultVideoDevice: AVCaptureDevice?
            // Choose the back wide angle camera if available, otherwise default to the front wide angle camera.
            if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                // Default to the front wide angle camera if the back wide angle camera is unavailable.
                defaultVideoDevice = frontCameraDevice
            } else {
                defaultVideoDevice = nil
            }
            
            guard let videoDevice = defaultVideoDevice else {
                print("Could not get video device")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            }
        }
        catch {
            print("Could not add video device input to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        if session.canAddOutput(metaDataOutput) {
            session.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: metaDataObjectsQueue)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        }
        else {
            print("Could not add metadata output to session")
            setupResult = .configurationFailed
            session.commitConfiguration()
        }
        session.commitConfiguration()
    }
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    private var isSessionRunning = false
    private var setupResult: SessionSetupResult = .success
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.session.stopRunning()
        self.isSessionRunning = self.session.isRunning
        for object in metadataObjects {
            guard let butt = object as? AVMetadataMachineReadableCodeObject, let barCode = butt.stringValue else { return }
            delegate.updateBarCode(with: barCode)
        }
//        session.startRunning()
    }
    
    func restartSession() {
        guard !self.isSessionRunning else { return }
        self.session.startRunning()
        self.isSessionRunning = self.session.isRunning
    }
}
