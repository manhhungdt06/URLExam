//
//  AddNewContactVC.swift
//  NSURLSession
//
//  Created by Vinh The on 7/27/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import UIKit

protocol AddNewPersonDelegate {
    func dismissAddnewPersonController(addNewVC: AddNewContactVC)
}

class AddNewContactVC: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var nameTextField: CustomTextField!
    
    @IBOutlet weak var phoneTextField: CustomTextField!
    
    @IBOutlet weak var cityTextField: CustomTextField!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var navLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: AddNewPersonDelegate?
    
    let baseUrl: String! = "http://localhost:2403/userinfo/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phoneTextField.delegate = self
        cityTextField.delegate = self
        emailTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setMask(view, rectCorner: [.BottomLeft,.BottomRight, .TopLeft, .TopRight], radius: CGSizeMake(20.0, 20.0))
        setMask(bannerView, rectCorner: [.TopLeft, .TopRight], radius: CGSizeMake(20.0, 20.0))
        
    }
    
    // MARK: post data
    
    func sendData(name: String, phoneNum: Int, address: String?, email: String?) {
        
        var param: [String: AnyObject] = ["name" : name, "phoneNum": phoneNum]
        
        if address != nil {
            param["address"] = address
        }
        
        if email != nil {
            param["email"] = email
        }
        
        let urlReq = NSMutableURLRequest(URL: NSURL(string: baseUrl)!)
        
        urlReq.HTTPMethod = "POST"
        
        let configSession = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        configSession.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        
        let createSession = NSURLSession(configuration: configSession)
        
        let dataUpload = try! NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions.PrettyPrinted)
        
        createSession.uploadTaskWithRequest(urlReq, fromData: dataUpload) { (data, ret, error) in
            if let error = error {
                print(error.code)
            }
            else {
                if let httpRet = ret as? NSHTTPURLResponse {
                    if httpRet.statusCode == 200 {

                        dispatch_async(dispatch_get_main_queue(), {
                            self.delegate?.dismissAddnewPersonController(self)
                        })
                    }
                    else {
                        print(httpRet.statusCode)
                    }
                }
            }
        }.resume()
    }
    
    
    // MARK: Create corner roundrect.
    
    func setMask(view : UIView, rectCorner : UIRectCorner, radius : CGSize){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: radius)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        maskLayer.borderWidth = 1.0
        maskLayer.borderColor = UIColor.blackColor().CGColor
        
        view.layer.mask = maskLayer
        
    }
    
    @IBAction func addNewContactAction(sender: AnyObject) {
        if let name = nameTextField.text, phone = Int(phoneTextField.text!) {
            sendData(name, phoneNum: phone, address: cityTextField.text, email: emailTextField.text)
        }
        else {
            print("error")
        }
    }
}


extension AddNewContactVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.setValue(UIColor.clearColor(), forKeyPath: "_placeholderLabel.textColor")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.setValue(UIColor.blackColor(), forKeyPath: "_placeholderLabel.textColor")
    }
}
