//
//  QRScannerViewController.swift
//  ICT_QR_Code
//
//  Created by MAC on 10/12/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var randomColor: UIColor {
        let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                      UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                      UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                      UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
        
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[index]
    }
    
    @IBOutlet var videoPreview: UIView!

    var avCaptureSession = AVCaptureSession()
    
    var imageString = String()
    
    enum error: Error {
        case noCameraAvilable
        case videoInputInitFil
    }
    
    var scann = 0;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barTintColor = randomColor
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2784313725, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        do {
            if scann == 0 {
                
                try scanQRCode()
                scann = scann + 1
            }
        }catch {
            print("fial to scan")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            print("stop scann")
            avCaptureSession.stopRunning()
            self.avCaptureSession.commitConfiguration()
            scann = 0
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                imageString = machineReadableCode.stringValue!
                performSegue(withIdentifier: "openImage", sender: self)
            }
        }
    }
    
    func scanQRCode() throws {
        
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("no camera")
            throw error.noCameraAvilable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("fale to init camera")
            
            throw error.videoInputInitFil
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if let inputs = avCaptureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                avCaptureSession.removeInput(input)
            }
        }
        
        if let outputs = avCaptureSession.outputs as? [AVCaptureOutput] {
            for output in outputs {
                avCaptureSession.removeOutput(output)
            }
        }
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        avCaptureVideoPreviewLayer.frame = self.videoPreview.bounds
        
//        self.view.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        print("run scann")
        avCaptureSession.startRunning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openImage" {
            let destination = segue.destination as! AfterScanViewController
            
            destination.imageString = imageString
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
