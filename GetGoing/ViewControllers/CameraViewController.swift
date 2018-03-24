//
//  CameraViewController.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-24.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class CameraViewController: UIViewController {


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var session: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
        }
        photoOutput = AVCapturePhotoOutput()
        if session!.canAddOutput(photoOutput!) {
            session!.addOutput(photoOutput!)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            previewView.layer.addSublayer(videoPreviewLayer!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session!.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let sess = self.session {
            sess.stopRunning()
        }
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
    }
    
    @IBAction func capturePhoto(_ sender: UIButton) {
        if photoOutput!.connection(with: AVMediaType.video) != nil {
            photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentPhoto", let destinationViewController = segue.destination as? PhotoViewController {
            destinationViewController.photo = self.photo
        }
    }
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async {
            if let photoRepresentation = photo.fileDataRepresentation() {
                self.photo = UIImage(data: photoRepresentation)
                self.performSegue(withIdentifier: "presentPhoto", sender: self)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
