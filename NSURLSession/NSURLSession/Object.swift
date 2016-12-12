//
//  File.swift
//  NSURLSession
//
//  Created by techmaster on 12/12/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import Foundation

class Object: NSObject {
    var id: String?
    var name: String?
    var address: String?
    var phoneNum: Int?
    var email: String?
    
    init(infomation : [String: AnyObject]) {
        
        let id = infomation["id"] as? String
        self.id = id
        
        let name = infomation["name"] as? String
        self.name = name
        
        let address = infomation["address"] as? String
        self.address = address
        
        let phoneNum = infomation["phoneNum"] as? Int
        self.phoneNum = phoneNum
        
        let email = infomation["email"] as? String
        self.email = email
        
    }
}
