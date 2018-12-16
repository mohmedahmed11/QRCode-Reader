//
//  ViewController.swift
//  ICT_QR_Code
//
//  Created by MAC on 08/12/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var QRCodeImage: UIImageView!
    let imageName = "myImage.jpg";
    
    var randomColor: UIColor {
        let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                      UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                      UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                      UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
        
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = randomColor
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2784313725, alpha: 1)
        //Create QR Code function Return UIImage
        if let image = generateQRCode(from: "pass your image string") {
            
            //display image in UIImageView
            QRCodeImage.image = image
            
            //convert image to string
//            let stringImage = image.toString()
            
            //convert string to uiimage
//            let imageString = stringImage?.toImage()
            
            //create sub String From stringImage
//            let subStr = stringImage?.prefix(34)
            
//            print("ima: \(imageString!)")
//            print("sub string is : \(subStr!)")
            
            //Save Image to Photo Album
            DispatchQueue.main.async {
                    UIImageWriteToSavedPhotosAlbum(image, self,#selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil);
            }
            
        } else {
            print("no")
        }
    }
    
    //Call Back After Save Image To Album
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your QRCode image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // func to generate QRCode Image work with String
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                
                return convert(cmage: output)
            }
        }
        return nil
    }
    
    //convert CIImage to UIImage
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}


extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = UIImagePNGRepresentation(self)
        return data?.base64EncodedString(options: .init(rawValue: 34))
    }
}
