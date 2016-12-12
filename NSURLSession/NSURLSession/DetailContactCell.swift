//
//  DetailContactCell.swift
//  NSURLSession
//
//  Created by Vinh The on 7/26/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import UIKit

class DetailContactCell: UITableViewCell {
    
    
    @IBOutlet weak var personalImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressImageView: UIImageView!
    
    @IBOutlet weak var phoneImageView: UIImageView!
    
    @IBOutlet weak var addressImageWidthContraint: NSLayoutConstraint!
    
    @IBOutlet weak var leadingBetweenPhoneImageViewAndAddressLabel: NSLayoutConstraint!
    
    @IBOutlet weak var leadingBetweenAddressImageViewAndAddressLabelContraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        personalImageView.layer.cornerRadius = personalImageView.bounds.size.width / 2.0
        
    }
    
    func updateUI(person : Object){
        
        nameLabel.text = person.name
        
        if let address = person.address {
            if address != "" {
                addressLabel.text = address
                updateDetailContentWhenHavingAddress()
            }else{
                addressLabel.text = ""
                updateDetailContentWhenNoAddress()
            }
        }
        
        if let phone = person.phoneNum {
            phoneLabel.text = String(phone)
        }else{
            phoneImageView.hidden = true
        }
        
    }
    
    func updateDetailContentWhenNoAddress(){
        addressImageWidthContraint.constant = 0
        leadingBetweenPhoneImageViewAndAddressLabel.constant = 0
        leadingBetweenAddressImageViewAndAddressLabelContraint.constant = 0
    }
    
    func updateDetailContentWhenHavingAddress() {
        
        addressImageWidthContraint.constant = 18.0
        
        leadingBetweenPhoneImageViewAndAddressLabel.constant = 4.0
        
        leadingBetweenAddressImageViewAndAddressLabelContraint.constant = 4.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
