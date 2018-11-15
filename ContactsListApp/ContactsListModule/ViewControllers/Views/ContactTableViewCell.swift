//
//  ContactTableViewCell.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    weak var contactModel:ContactModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(contact:ContactModel) {
        self.contactModel = contact
        self.contactNameLabel.text = contact.name
        self.contactImageView.image = nil
        self.contactImageView.alpha = 0
        
        contact.getImage(completion: {[weak self] (data:Data?) ->() in
            if data != nil , let image = UIImage(data: data!) {
                self?.contactImageView.image = image
            } else {
                self?.contactImageView.image = #imageLiteral(resourceName: "default")
            }
            UIView.animate(withDuration: 0.25,
                           animations: {
                            self?.contactImageView.alpha = 1
            },
                           completion:nil
            )
            }
        )
    }
    
    
    
}
