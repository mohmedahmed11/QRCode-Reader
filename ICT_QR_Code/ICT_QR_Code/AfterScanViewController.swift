//
//  AfterScanViewController.swift
//  ICT_QR_Code
//
//  Created by MAC on 10/12/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class AfterScanViewController: UIViewController {
    
    var randomColor: UIColor {
        let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                      UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                      UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                      UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
        
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[index]
    }
    
    @IBOutlet var QRCode: UIImageView!
    
    var imageString:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = randomColor
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2784313725, alpha: 1)
        
        if let image = generateQRCode(from: imageString) {
            //display image in UIImageView
            QRCode.image = image
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
