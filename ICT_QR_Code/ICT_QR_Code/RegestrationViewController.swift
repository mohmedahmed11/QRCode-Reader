//
//  RegestrationViewController.swift
//  ICT_QR_Code
//
//  Created by MAC on 10/12/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import Foundation

class RegestrationViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    let pickerArray = ["1", "2", "3", "4", "5"]

    @IBOutlet weak var hearUs: UITextView!
    
    @IBOutlet weak var pickerTextField : UITextField!
    @IBOutlet weak var universitys : UITextField!
    @IBOutlet weak var otherUniversitys : UITextField!
    @IBOutlet weak var work : UITextField!
    @IBOutlet weak var job : UITextField!
    @IBOutlet weak var universityView : UIView!
    @IBOutlet weak var otherUniversityView : UIView!
    @IBOutlet weak var workView : UIView!
    @IBOutlet weak var otherJobView : UIView!
    
    var pickerView = UIPickerView()
    var currentTextFied = UITextField()
    
    let questions = ["", "Student", "Worker"]
    let univers = ["", "Khartoum", "Sudan", "Neelain", "Other"]
    let jobs = ["", "IOS", "Android", "php", "nodejs","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        universityView.isHidden = true
        otherUniversityView.isHidden = true
        workView.isHidden = true
        otherJobView.isHidden = true
        hearUs.placeholder = "Where did you hear us?"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if currentTextFied == pickerTextField {
            return questions.count
        } else if currentTextFied == universitys {
            return univers.count
        } else if currentTextFied == job {
            return jobs.count
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if currentTextFied == pickerTextField {
            return questions[row]
        } else if currentTextFied == universitys {
            return univers[row]
        } else if currentTextFied == job {
            return jobs[row]
        } else {
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currentTextFied == pickerTextField {
            if questions[row] == "Student" {
                universityView.fadeIn()
                workView.fadeOut()
            }else if questions[row] == "Worker" {
                universityView.fadeOut()
                workView.fadeIn()
            }else {
                universityView.fadeOut()
                workView.fadeOut()
            }
            pickerTextField.text = questions[row]
            
        }else if currentTextFied == universitys {
            if row == univers.count - 1 {
                otherUniversityView.fadeIn()
            } else {
                otherUniversityView.fadeOut()
            }
            universitys.text = univers[row]
        }else if currentTextFied == job {
            if row == jobs.count - 1 {
                otherJobView.fadeIn()
            } else {
                otherUniversityView.fadeOut()
            }
            job.text = jobs[row]
        }
        
        self.view.layoutIfNeeded()
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        currentTextFied = textField
        if currentTextFied == pickerTextField {
            pickerTextField.inputView = pickerView
        } else if currentTextFied == universitys {
            universitys.inputView = pickerView
        } else if currentTextFied == job {
            job.inputView = pickerView
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


extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

