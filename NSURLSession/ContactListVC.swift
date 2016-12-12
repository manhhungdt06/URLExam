//
//  ContactListVC.swift
//  NSURLSession
//
//  Created by Vinh The on 7/26/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import UIKit

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var myTableView: UITableView!

    let baseUrl: String! = "http://localhost:2403/userinfo/"
    
    var infoPerson = [Object]()
    
    var delegate: AddNewPersonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self

        navigationItem.title = "Contact List"
        navigationItem.rightBarButtonItem = addBarButton()

        getDataRequest()
    }

    // MARK: TableView configuration

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoPerson.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! DetailContactCell
        
        let person = infoPerson[indexPath.row]
        
        cell.updateUI(person)

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Default, title: "DELETE") { (rowAction, indexPath) in
            
            print("delete")
            self.deleteRequest(indexPath)

        }
//        delete.backgroundColor = UIColor.blueColor()
        
        let edit = UITableViewRowAction(style: .Normal, title: "EDIT") { (rowAction, indexPath) in
            
            let editPerson = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewContactVC") as! AddNewContactVC
            
            editPerson.delegate = self
            
            self.displayContentController(editPerson)
            
            
            let id = self.infoPerson[indexPath.row].id!
            
            print("id = \(id)")
            
            let name = self.infoPerson[indexPath.row].name!
            editPerson.nameTextField.text = name
            
            let address = self.infoPerson[indexPath.row].address!
            editPerson.cityTextField.text = address
            
            let phoneNum = self.infoPerson[indexPath.row].phoneNum!
            editPerson.phoneTextField.text = String(phoneNum)
            
            let email = self.infoPerson[indexPath.row].email!
            editPerson.emailTextField.text = email

            self.putRequest(editPerson.nameTextField.text!, phoneNum: Int(editPerson.phoneTextField.text!)!, address: editPerson.cityTextField.text, email: editPerson.emailTextField.text, id: id)
        }

        return [delete, edit]
        
    }
    
    // MARK: delete data
    
    func deleteRequest(index: NSIndexPath) {
        
        let id = infoPerson[index.row].id
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: baseUrl + id!)!)
        
        urlRequest.HTTPMethod = "DELETE"
        
        let configureSession = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: configureSession)
        
        session.dataTaskWithRequest(urlRequest) { (data, ret, error) in
            if let error = error {
                print("error.code = \(error.code)")
            }
            else {
                if let httpRet = ret as? NSHTTPURLResponse {
                    if httpRet.statusCode == 200 {
                        self.infoPerson.removeAtIndex(index.row)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.myTableView.deleteRowsAtIndexPaths([index], withRowAnimation: .Automatic)
                        })
                    }
                    else {
                        print("httpRet = \(httpRet.statusCode)")
                    }
                }
            }
        }.resume()
        
    }
    
    // MARK: put data
    
    func putRequest(name: String, phoneNum: Int, address: String?, email: String?, id: String?) {
        
        var param: [String: AnyObject] = ["name" : name, "phoneNum": phoneNum]
        
        if address != nil {
            param["address"] = address
        }
        
        if email != nil {
            param["email"] = email
        }
        
        let urlReq = NSMutableURLRequest(URL: NSURL(string: baseUrl + id!)!)
        
        urlReq.HTTPMethod = "PUT"
        
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
                            self.delegate?.dismissAddnewPersonController(self.popUpVC!)
                        })
                    }
                    else {
                        print(httpRet.statusCode)
                    }
                }
            }
            }.resume()
    }

    //MARK: get data request
    
    // getDataRequest
    func getDataRequest() {
        let urlReq = NSURLRequest(URL: NSURL(string: baseUrl)!)
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithRequest(urlReq) { (data, ret, error) in
            if let error = error {
                print(error.code)
            }
            else {
                if let httpRet = ret as? NSHTTPURLResponse {
                    if httpRet.statusCode == 200 {
                        guard let info = data else {return}
                        do {
                            let result = try NSJSONSerialization.JSONObjectWithData(info, options: NSJSONReadingOptions.AllowFragments)
                            if let arrResult: AnyObject = result {
                                for dictData in arrResult as! [AnyObject] {
                                    if let infoData = dictData as? [String: AnyObject] {
                                        self.infoPerson.append(Object(infomation: infoData))
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.myTableView.reloadData()
                                        })
                                        
                                    }
                                }
                            }
                        }
                        catch let error as NSError {
                            print(error.description)
                        }
                    }
                    else {
                        print(httpRet.statusCode)
                    }
                }
            }
        }.resume()
    }


    //MARK: Create BarButton

    func addBarButton() -> UIBarButtonItem{

        let addNewContactBarButton = UIBarButtonItem(image: UIImage(named: "Add New Bar Button")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(addNewContact(_:)))

        return addNewContactBarButton
    }

    func addNewContact(sender : AnyObject) {
        let addNewContact = storyboard?.instantiateViewControllerWithIdentifier("AddNewContactVC") as! AddNewContactVC
        
        addNewContact.delegate = self
        
        displayContentController(addNewContact)

    }

// MARK: Create Popup

    var blurView : UIView?
    var popUpVC : AddNewContactVC?

    func createBlurView() -> UIView {
        let blurView = UIView(frame: view.bounds)
        blurView.backgroundColor = UIColor.blackColor()
        blurView.alpha = 0.5

        return blurView
    }

    func displayContentController(content : AddNewContactVC) {

        popUpVC = content

        blurView = createBlurView()
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDismissGesture(_:)))
        blurView?.addGestureRecognizer(dismissTapGesture)

        view.addSubview(blurView!)
        navigationItem.rightBarButtonItem?.enabled = false

        addChildViewController(content)
        content.view.bounds = CGRectMake(0, 0, view.bounds.width / 1.2, view.bounds.height / 1.3)
        content.view.alpha = 0.5

        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {

            content.view.alpha = 1.0
            content.view.center = CGPoint(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 2.0)
            self.view.addSubview(content.view)
            content.didMoveToParentViewController(self)

            }, completion: nil)

    }



    func animateDismissAddNewContactView(addNewVC : AddNewContactVC) {
        let bounds = addNewVC.view.bounds

        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {

            addNewVC.view.alpha = 0.5
            addNewVC.view.center = CGPointMake(self.view.bounds.width / 2.0, -bounds.height)
            self.blurView?.alpha = 0.0

        }){(Bool) in
            addNewVC.view.removeFromSuperview()
            addNewVC.removeFromParentViewController()
            self.navigationItem.rightBarButtonItem?.enabled = true
            self.blurView?.removeFromSuperview()
        }

    }

    func tapDismissGesture(tapGesture : UITapGestureRecognizer) {
        animateDismissAddNewContactView(popUpVC!)
    }
}

extension ContactListVC: AddNewPersonDelegate {
    func dismissAddnewPersonController(addNewVC: AddNewContactVC) {
        animateDismissAddNewContactView(addNewVC)
        infoPerson.removeAll()
        getDataRequest()
    }
}
